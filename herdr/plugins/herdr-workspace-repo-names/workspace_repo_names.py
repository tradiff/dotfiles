#!/usr/bin/env python3
"""Keep automatically named Herdr workspaces aligned with their Git repositories."""

import fcntl
import hashlib
import json
import os
from pathlib import Path
import select
import socket
import subprocess
import sys
import tempfile
import time


POLL_SECONDS = 1
GIT_CACHE_SECONDS = 10
ENABLED_CHECK_SECONDS = 10
PLUGIN_ID = "travis.workspace-repo-names"


def herdr(*args):
    result = subprocess.run(
        [os.environ.get("HERDR_BIN_PATH", "herdr"), *args],
        capture_output=True,
        check=True,
        text=True,
        timeout=10,
    )
    return json.loads(result.stdout)["result"]


def git_path(cwd, *args):
    try:
        output = subprocess.run(
            ["git", "-C", cwd, "rev-parse", *args],
            capture_output=True,
            check=True,
            text=True,
            timeout=5,
        ).stdout.rstrip("\n")
        return Path(output) if output else None
    except (OSError, subprocess.SubprocessError):
        return None


def fallback_name(cwd):
    if cwd == str(Path.home()):
        return "~"
    return Path(cwd).name or cwd


def names_for_cwd(cwd):
    """Return (Herdr's automatic name, the common repository's name)."""
    if not cwd:
        return None, None
    root = git_path(cwd, "--show-toplevel")
    common = git_path(cwd, "--path-format=absolute", "--git-common-dir")
    automatic = root.name if root else fallback_name(cwd)
    if not common:
        return automatic, None
    # A linked worktree's root is its checkout directory, but the common Git
    # directory belongs to the original repository.
    if common.name in (".git", ".bare"):
        repo = common.parent.name
    else:
        repo = common.name.removesuffix(".git")
    return automatic, repo or None


def pane_number(pane):
    alphabet = "123456789ABCDEFGHJKMNPQRSTVWXYZ0"
    value = 0
    for char in pane["pane_id"].split(":p", 1)[1]:
        value = value * len(alphabet) + alphabet.index(char) + 1
    return value


def workspace_cwd(workspace, tabs, panes):
    """Use the first tab's oldest pane, the usual workspace identity pane."""
    first_tab = next(
        (tab for tab in tabs if tab["workspace_id"] == workspace["workspace_id"]), None
    )
    if not first_tab:
        return None
    candidates = [pane for pane in panes if pane["tab_id"] == first_tab["tab_id"]]
    if not candidates:
        return None
    return min(candidates, key=pane_number).get("cwd")


def saved_workspace_names(socket_path):
    """Read manual-name flags that Herdr does not expose through its API."""
    try:
        with Path(socket_path).with_name("session.json").open() as file:
            workspaces = json.load(file)["workspaces"]
        return {workspace["id"]: workspace["custom_name"] for workspace in workspaces}
    except (OSError, ValueError, KeyError, TypeError):
        return {}


class RepoNames:
    def __init__(self, state_path, call=herdr, read_saved_names=None):
        self.state_path = state_path
        self.call = call
        self.entries = self.load_state()
        self.read_saved_names = read_saved_names
        self.pending = {}
        self.git_cache = {}

    def load_state(self):
        try:
            with self.state_path.open() as file:
                return json.load(file)["workspaces"]
        except (OSError, ValueError, KeyError):
            return {}

    def save_state(self):
        self.state_path.parent.mkdir(parents=True, exist_ok=True)
        fd, path = tempfile.mkstemp(dir=self.state_path.parent)
        try:
            with os.fdopen(fd, "w") as file:
                json.dump({"workspaces": self.entries}, file)
                file.write("\n")
            os.replace(path, self.state_path)
        finally:
            Path(path).unlink(missing_ok=True)

    def names(self, cwd):
        now = time.monotonic()
        cached = self.git_cache.get(cwd)
        if cached and now - cached[0] < GIT_CACHE_SECONDS:
            return cached[1]
        self.git_cache = {
            path: item for path, item in self.git_cache.items()
            if now - item[0] < GIT_CACHE_SECONDS
        }
        names = names_for_cwd(cwd)
        self.git_cache[cwd] = (now, names)
        return names

    def sync(self):
        snapshot = self.call("api", "snapshot")["snapshot"]
        workspaces = snapshot["workspaces"]
        tabs = snapshot["tabs"]
        panes = snapshot["panes"]
        live_ids = {workspace["workspace_id"] for workspace in workspaces}
        changed = False
        for workspace_id in self.entries.keys() - live_ids:
            del self.entries[workspace_id]
            self.pending.pop(workspace_id, None)
            changed = True

        saved_names = None
        for workspace in workspaces:
            workspace_id = workspace["workspace_id"]
            entry = self.entries.get(workspace_id)
            if entry and entry.get("manual"):
                continue
            if not entry and self.read_saved_names is not None:
                if saved_names is None:
                    saved_names = self.read_saved_names()
                if workspace_id not in saved_names:
                    continue  # Wait for Herdr to save the new workspace's name flag.
                if saved_names[workspace_id] is not None:
                    self.entries[workspace_id] = {"manual": True}
                    changed = True
                    continue
            cwd = workspace_cwd(workspace, tabs, panes)
            if not cwd:
                continue
            automatic, repo = self.names(cwd)
            expected = entry["last_name"] if entry else automatic
            if workspace["label"] != expected:
                self.entries[workspace_id] = {"manual": True}
                changed = True
                continue

            desired = repo or automatic
            if desired == workspace["label"]:
                continue
            self.pending.setdefault(workspace_id, []).append(desired)
            try:
                self.call("workspace", "rename", workspace_id, desired)
            except Exception:
                self.pending[workspace_id].pop()
                if not self.pending[workspace_id]:
                    del self.pending[workspace_id]
                raise
            self.entries[workspace_id] = {"last_name": desired}
            changed = True

        if changed:
            self.save_state()

    def on_event(self, event):
        if event.get("event") != "workspace_renamed":
            return
        workspace_id = event["data"]["workspace_id"]
        label = event["data"]["label"]
        pending = self.pending.get(workspace_id, [])
        if pending and pending[0] == label:
            pending.pop(0)
            if not pending:
                del self.pending[workspace_id]
            return
        if self.entries.get(workspace_id) != {"manual": True}:
            self.entries[workspace_id] = {"manual": True}
            self.save_state()


def state_path():
    socket_path = os.environ["HERDR_SOCKET_PATH"]
    session = hashlib.sha256(socket_path.encode()).hexdigest()[:16]
    return Path(os.environ["HERDR_PLUGIN_STATE_DIR"]) / f"{session}.json"


def watch():
    state = state_path()
    state.parent.mkdir(parents=True, exist_ok=True)
    with (state.parent / f"{state.stem}.lock").open("w") as lock:
        try:
            fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            return  # Another watcher already owns this session.

        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
            client.connect(os.environ["HERDR_SOCKET_PATH"])
            request = {
                "id": "workspace-repo-names",
                "method": "events.subscribe",
                "params": {"subscriptions": [
                    {"type": "workspace.renamed"},
                    {"type": "workspace.created"},
                    {"type": "workspace.closed"},
                ]},
            }
            client.sendall((json.dumps(request) + "\n").encode())
            # Unbuffered reads keep select() in sync with unread event lines.
            with client.makefile("rb", buffering=0) as stream:
                response = json.loads(stream.readline())
                if "error" in response:
                    raise RuntimeError(response["error"])

                socket_path = os.environ["HERDR_SOCKET_PATH"]
                namer = RepoNames(
                    state,
                    read_saved_names=lambda: saved_workspace_names(socket_path),
                )
                next_sync = 0
                next_enabled_check = time.monotonic() + ENABLED_CHECK_SECONDS
                while True:
                    now = time.monotonic()
                    if now >= next_enabled_check:
                        plugins = herdr("plugin", "list", "--plugin", PLUGIN_ID, "--json")
                        if not plugins["plugins"] or not plugins["plugins"][0]["enabled"]:
                            return
                        next_enabled_check = now + ENABLED_CHECK_SECONDS
                    if now >= next_sync:
                        namer.sync()
                        next_sync = time.monotonic() + POLL_SECONDS
                    ready, _, _ = select.select(
                        [client], [], [], max(0, min(next_sync, next_enabled_check) - time.monotonic())
                    )
                    if ready:
                        line = stream.readline()
                        if not line:
                            return  # The server exited; its next startup starts a new watcher.
                        event = json.loads(line)
                        namer.on_event(event)
                        if event.get("event") in ("workspace_created", "workspace_closed"):
                            next_sync = 0


if __name__ == "__main__":
    if sys.argv[1:] == ["--watch"]:
        try:
            watch()
        except Exception as error:
            print(error, file=sys.stderr)
            sys.exit(1)
    else:
        print("usage: workspace_repo_names.py --watch", file=sys.stderr)
        sys.exit(2)
