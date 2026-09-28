import copy
import json
from pathlib import Path
import subprocess
import tempfile
import unittest

from workspace_repo_names import RepoNames, names_for_cwd, saved_workspace_names, workspace_cwd


def git(*args):
    subprocess.run(["git", *map(str, args)], capture_output=True, check=True)


class FakeHerdr:
    def __init__(self, cwd, label):
        self.snapshot = {
            "workspaces": [{"workspace_id": "w1", "label": label}],
            "tabs": [{"workspace_id": "w1", "tab_id": "w1:t1"}],
            "panes": [{"tab_id": "w1:t1", "pane_id": "w1:p1", "cwd": str(cwd)}],
        }
        self.renames = []

    def __call__(self, *args):
        if args == ("api", "snapshot"):
            return {"snapshot": copy.deepcopy(self.snapshot)}
        if args[:2] == ("workspace", "rename"):
            self.snapshot["workspaces"][0]["label"] = args[3]
            self.renames.append(args[3])
            return {}
        raise AssertionError(args)

    def cd(self, cwd):
        self.snapshot["panes"][0]["cwd"] = str(cwd)

    def rename_manually(self, name, namer):
        self.snapshot["workspaces"][0]["label"] = name
        namer.on_event({
            "event": "workspace_renamed",
            "data": {"workspace_id": "w1", "label": name},
        })


class WorkspaceRepoNamesTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(dir="/tmp/opencode")
        self.addCleanup(self.tmp.cleanup)
        self.base = Path(self.tmp.name)
        self.repo = self.base / "my-repo"
        self.repo.mkdir()
        git("init", "-q", self.repo)
        git("-C", self.repo, "-c", "user.name=Test", "-c", "user.email=test@example.com",
            "commit", "-q", "--allow-empty", "-m", "init")
        self.checkout = self.base / "feature-branch"
        git("-C", self.repo, "worktree", "add", "-q", "-b", "feature", self.checkout)
        self.state = self.base / "state.json"

    def test_git_repo_and_linked_worktree_names(self):
        nested = self.repo / "src" / "deep"
        nested.mkdir(parents=True)
        self.assertEqual(names_for_cwd(str(nested)), ("my-repo", "my-repo"))
        self.assertEqual(names_for_cwd(str(self.checkout)), ("feature-branch", "my-repo"))
        self.assertEqual(names_for_cwd(str(self.base)), (self.base.name, None))

    def test_names_follow_cd_and_fall_back_outside_git(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        namer = RepoNames(self.state, fake)
        namer.sync()
        self.assertEqual(fake.renames, ["my-repo"])
        self.assertEqual(namer.pending, {"w1": ["my-repo"]})
        namer.on_event({
            "event": "workspace_renamed",
            "data": {"workspace_id": "w1", "label": "my-repo"},
        })
        self.assertEqual(namer.pending, {})

        fake.cd(self.base)
        namer.sync()
        self.assertEqual(fake.renames, ["my-repo", self.base.name])
        fake.cd(self.checkout)
        namer.sync()
        self.assertEqual(fake.renames, ["my-repo", self.base.name, "my-repo"])

    def test_manual_rename_stops_updates_even_if_name_is_unchanged(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        namer = RepoNames(self.state, fake)
        namer.sync()
        namer.on_event({
            "event": "workspace_renamed",
            "data": {"workspace_id": "w1", "label": "my-repo"},
        })  # Our rename event.
        fake.rename_manually("my-repo", namer)
        fake.cd(self.base)
        namer.sync()
        self.assertEqual(fake.renames, ["my-repo"])
        self.assertTrue(RepoNames(self.state, fake).entries["w1"]["manual"])

    def test_preexisting_manual_name_is_preserved(self):
        fake = FakeHerdr(self.checkout, "my custom name")
        namer = RepoNames(self.state, fake)
        namer.sync()
        self.assertEqual(fake.renames, [])
        self.assertTrue(namer.entries["w1"]["manual"])

    def test_saved_manual_name_matching_automatic_name_is_preserved(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        namer = RepoNames(self.state, fake, read_saved_names=lambda: {"w1": "feature-branch"})
        namer.sync()
        self.assertEqual(fake.renames, [])
        self.assertTrue(namer.entries["w1"]["manual"])

    def test_saved_automatic_name_is_renamed(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        RepoNames(self.state, fake, read_saved_names=lambda: {"w1": None}).sync()
        self.assertEqual(fake.renames, ["my-repo"])

    def test_unknown_existing_workspace_is_left_alone(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        RepoNames(self.state, fake, read_saved_names=lambda: {}).sync()
        self.assertEqual(fake.renames, [])

    def test_new_workspace_waits_for_saved_automatic_name(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        saved = {}
        namer = RepoNames(self.state, fake, read_saved_names=lambda: saved)
        namer.sync()
        self.assertEqual(fake.renames, [])
        saved["w1"] = None
        namer.sync()
        self.assertEqual(fake.renames, ["my-repo"])

    def test_new_workspace_with_manual_name_matching_automatic_is_preserved(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        saved = {}
        namer = RepoNames(self.state, fake, read_saved_names=lambda: saved)
        namer.sync()
        saved["w1"] = "feature-branch"
        namer.sync()
        self.assertEqual(fake.renames, [])
        self.assertTrue(namer.entries["w1"]["manual"])

    def test_reads_manual_names_from_herdr_session_file(self):
        (self.base / "session.json").write_text(json.dumps({"workspaces": [
            {"id": "w1", "custom_name": "feature-branch"},
            {"id": "w2", "custom_name": None},
        ]}))
        self.assertEqual(saved_workspace_names(self.base / "herdr.sock"), {
            "w1": "feature-branch", "w2": None,
        })

    def test_previous_plugin_name_survives_restart_but_manual_change_does_not(self):
        fake = FakeHerdr(self.checkout, "feature-branch")
        RepoNames(self.state, fake).sync()
        fake.cd(self.base)
        RepoNames(self.state, fake).sync()
        self.assertEqual(fake.renames, ["my-repo", self.base.name])

        fake.snapshot["workspaces"][0]["label"] = "custom while offline"
        fake.cd(self.checkout)
        RepoNames(self.state, fake).sync()
        self.assertEqual(fake.renames, ["my-repo", self.base.name])

    def test_normal_repo_needs_no_rename(self):
        fake = FakeHerdr(self.repo, "my-repo")
        namer = RepoNames(self.state, fake)
        namer.sync()
        self.assertEqual(fake.renames, [])
        self.assertEqual(namer.entries, {})

    def test_first_tab_oldest_pane_supplies_directory(self):
        workspace = {"workspace_id": "w1"}
        tabs = [
            {"workspace_id": "w1", "tab_id": "w1:t1"},
            {"workspace_id": "w1", "tab_id": "w1:t2"},
        ]
        panes = [
            {"tab_id": "w1:t1", "pane_id": "w1:p3", "cwd": "/other"},
            {"tab_id": "w1:t2", "pane_id": "w1:p2", "cwd": "/tab-two"},
            {"tab_id": "w1:t1", "pane_id": "w1:p1", "cwd": str(self.repo)},
        ]
        self.assertEqual(workspace_cwd(workspace, tabs, panes), str(self.repo))


if __name__ == "__main__":
    unittest.main()
