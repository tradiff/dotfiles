# herdr-workspace-repo-names

Automatically named workspaces use the Git repository name instead of the
directory name. Outside Git, they use Herdr's
normal directory name. The plugin follows the working directory of the oldest
pane in the workspace's first tab. A manual rename stops automatic updates.

## Install

```sh
herdr plugin link /path/to/herdr-workspace-repo-names
herdr plugin action invoke travis.workspace-repo-names.start
```

The action starts the watcher immediately. Herdr also starts it when the server
starts.

## Manual names

Herdr's public workspace API exposes the displayed label but not whether it was
set manually. The plugin reads `session.json` beside the session socket to
protect manual names, even when they match Herdr's default. It stores the names
it sets in Herdr's plugin state directory, separately for each session.

New workspaces can take about five seconds to rename while Herdr saves them.
