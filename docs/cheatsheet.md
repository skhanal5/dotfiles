# Cheat sheet

Run `cheat` to show this file. Run `tldr <command>` for short examples of any command.

Learn one section per week. Delete a line once it is a habit. When a whole section is a habit, remove its tips from `zsh/.zshrc`.

## Week 1: search and jump

| Do this | Instead of |
| --- | --- |
| `Ctrl-R` to search history with fzf | pressing up many times |
| `Ctrl-T` to insert a file path | typing a long path |
| `Alt-C` to jump into a folder | `cd` plus many tabs |
| `z <part of name>` to jump to a folder you used before | `cd ../../some/long/path` |
| `zi` to pick a folder from a list | guessing the name |
| `Ctrl-L` to clear the screen | `clear` |
| `gst`, `gco`, `gaa` (you-should-use reminds you) | `git status`, `git checkout`, `git add --all` |

## Week 2: read files and diffs

| Do this | Instead of |
| --- | --- |
| `ll` for details and git status | `ls -l` |
| `la` to also show hidden files | `ls -la` |
| `lt` for a tree | `tree` |
| `bat <file>` for colors and line numbers | `cat` |
| `n` and `N` in a diff to jump between files | scrolling |

## Week 3: Kubernetes

| Do this | Instead of |
| --- | --- |
| `k` | `kubectl` |
| `kgp`, `kgs`, `kgd` (get pods, services, deployments) | `kubectl get ...` |
| `k9s`, then `:pods`, `:svc`, `:deploy` | many `kubectl get` calls |
| In k9s: `d` describe, `l` logs, `s` shell, `/` filter | `kubectl describe`, `logs`, `exec` |
| `kubectx` to switch cluster, `kubens` to switch namespace | `kubectl config use-context` |

## Week 4: git UI

| Do this | Instead of |
| --- | --- |
| `lg` to open lazygit | many git commands |
| In lazygit: `space` stage, `c` commit, `P` push, `p` pull | `git add`, `commit`, `push`, `pull` |
| In lazygit: `?` shows all keys | guessing |

## Later: project setup

| Do this | Instead of |
| --- | --- |
| `.envrc` with `export` lines, then `direnv allow` | exporting vars by hand each time |
| `mise use node@<version>` in a project | installing a global version |
| `mise ls` to see active versions | `java -version`, `node -v` |
