#!/usr/bin/env python3
"""Name Herdr panes from terminal titles."""

import json
import os
import socket
import subprocess
import sys
import time


MAX_RETRY_SECONDS = 30


def run(*args):
    return subprocess.run(
        [os.environ.get("HERDR_BIN_PATH", "herdr"), *args],
        capture_output=True,
        check=True,
        text=True,
        timeout=10,
    ).stdout


def renames(panes):
    for pane in panes:
        pane_id = pane.get("pane_id")
        title = (pane.get("terminal_title_stripped") or "").strip()
        if pane_id and title and pane.get("label") != title:
            yield pane_id, title


def rename_panes():
    panes = json.loads(run("pane", "list"))["result"]["panes"]
    count = 0
    for pane_id, title in renames(panes):
        run("pane", "rename", pane_id, title)
        count += 1
    return count


def watch():
    socket_path = os.environ["HERDR_SOCKET_PATH"]
    request = json.dumps({
        "id": "pane-namer",
        "method": "events.subscribe",
        "params": {"subscriptions": [{"type": "pane.updated"}]},
    }) + "\n"
    failures = 0

    while True:
        try:
            with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
                client.connect(socket_path)
                client.sendall(request.encode())
                with client.makefile() as messages:
                    for message in messages:
                        failures = 0
                        pane = json.loads(message).get("data", {}).get("pane")
                        if pane:
                            for pane_id, title in renames([pane]):
                                try:
                                    run("pane", "rename", pane_id, title)
                                except subprocess.CalledProcessError as error:
                                    print(error, file=sys.stderr)
            raise ConnectionError("Herdr event subscription closed")
        except Exception as error:
            failures += 1
            print(error, file=sys.stderr)
            time.sleep(min(2 ** (failures - 1), MAX_RETRY_SECONDS))


def check():
    assert list(renames([
        {"pane_id": "w1:p1", "terminal_title_stripped": "Build docs"},
        {"pane_id": "w1:p2", "terminal_title_stripped": "Up to date", "label": "Up to date"},
        {"pane_id": "w1:p3"},
    ])) == [("w1:p1", "Build docs")]


if __name__ == "__main__":
    if sys.argv[1:] == ["--check"]:
        check()
    elif sys.argv[1:] == ["--watch"]:
        watch()
    else:
        print("renamed %d pane(s)" % rename_panes())
