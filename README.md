# Dotfiles

Personal macOS development environment setup.

This repository contains my shell and terminal configuration, along with a bootstrap script to recreate my environment on a new machine.

## Usage

Clone the repository:

```bash
git clone <repo-url> ~/Projects/dotfiles
cd ~/Projects/dotfiles
```

Run the installer:

```bash
./install.sh
```

The installer will:

- Install required tools
- Configure the shell environment
- Install shell plugins
- Set up Ghostty and tmux configuration
- Link the global git config and git ignore file
- Link Claude Code skills and the global `CLAUDE.md`
- Create symlinks so this repo remains the source of truth

After installation, restart your terminal.

## Claude Code

The `claude/` folder holds Claude Code skills and the global `CLAUDE.md` policy. See [claude/README.md](claude/README.md) for the skill rules, the check script, and evals.

## Configuration

All configuration changes should be made inside this repository.

The setup uses symlinks so the repository remains the source of truth for your local environment.

Example:

```bash
vim zsh/.zshrc
```

Reload zsh:

```bash
source ~/.zshrc
```

Reload Ghostty:

```
Cmd + Shift + ,
```

## Backup

Existing configuration files are backed up before being replaced.

The installer will:

- Install Homebrew packages and applications
- Configure the shell environment
- Install shell plugins
- Set up Ghostty configuration
- Create symlinks so this repo remains the source of truth
