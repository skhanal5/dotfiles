#!/bin/bash

set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "Installing dotfiles from:"
echo "$DOTFILES"

# =============================================================================
# Symlink helper
# =============================================================================

link_file () {
  SOURCE="$1"
  TARGET="$2"

  if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
    if [ -L "$TARGET" ]; then
      rm "$TARGET"
    else
      mv "$TARGET" "$TARGET.backup"
    fi
  fi

  mkdir -p "$(dirname "$TARGET")"
  ln -s "$SOURCE" "$TARGET"
}

# =============================================================================
# Config links (moved up so .zshenv exists before Homebrew needs it)
# =============================================================================

echo "Linking configs..."

link_file \
  "$DOTFILES/zsh/.zshenv" \
  "$HOME/.zshenv"

link_file \
  "$DOTFILES/zsh/.zshrc" \
  "$HOME/.zshrc"

link_file \
  "$DOTFILES/ghostty/config" \
  "$HOME/.config/ghostty/config"

link_file \
  "$DOTFILES/tmux/tmux.conf" \
  "$HOME/.config/tmux/tmux.conf"

link_file \
  "$DOTFILES/git/gitconfig" \
  "$HOME/.gitconfig"

link_file \
  "$DOTFILES/git/ignore" \
  "$HOME/.config/git/ignore"

# =============================================================================
# Claude Code
# =============================================================================

echo "Linking Claude Code config..."

link_file \
  "$DOTFILES/claude/CLAUDE.md" \
  "$HOME/.claude/CLAUDE.md"

# Merge, do not link. The live file keeps keys that belong to this machine
# only, such as autoMode. The repo copy must never hold those keys.
SETTINGS="$HOME/.claude/settings.json"

if [ ! -e "$SETTINGS" ]; then
  cp "$DOTFILES/claude/settings.json" "$SETTINGS"
elif command -v jq >/dev/null 2>&1; then
  # Repo values win for the keys the repo sets. Other keys stay.
  jq -s '.[0] * .[1]' "$SETTINGS" "$DOTFILES/claude/settings.json" > "$SETTINGS.tmp"
  rm "$SETTINGS"
  mv "$SETTINGS.tmp" "$SETTINGS"
else
  echo "jq not found. Skipped merge into $SETTINGS."
fi

link_file \
  "$DOTFILES/claude/statusline-command.sh" \
  "$HOME/.claude/statusline-command.sh"

# Link each skill on its own. Other tools also install skills in this folder.
# Back up real folders outside the skills folder. A backup inside it would load as a duplicate skill.
SKILLS_TARGET="$HOME/.claude/skills"
SKILLS_BACKUP="$HOME/.claude/skills-backup"
mkdir -p "$SKILLS_TARGET"

for skill in "$DOTFILES"/claude/skills/*/; do
  name="$(basename "$skill")"
  target="$SKILLS_TARGET/$name"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    mkdir -p "$SKILLS_BACKUP"
    rm -rf "$SKILLS_BACKUP/$name"
    mv "$target" "$SKILLS_BACKUP/$name"
  fi

  link_file "${skill%/}" "$target"
done

# =============================================================================
# Homebrew
# =============================================================================

if ! command -v brew >/dev/null 2>&1; then
  echo "Installing Homebrew..."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  if [ "$(uname -m)" = "arm64" ]; then
    # NOTE: brew shellenv now lives in zsh/.zshenv (tracked in this repo)
    # and was already symlinked to ~/.zshenv above. We just need to eval
    # it here so the rest of this script run can see `brew` immediately.
    eval "$(/opt/homebrew/bin/brew shellenv)"
  fi
fi

# =============================================================================
# Brew packages
# =============================================================================

echo "Installing packages..."

brew bundle --file="$DOTFILES/Brewfile"

# =============================================================================
# Oh My Zsh
# =============================================================================

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."

  RUNZSH=no \
  CHSH=no \
  KEEP_ZSHRC=yes \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# =============================================================================
# Zsh plugins
# =============================================================================

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."

  git clone \
    https://github.com/zsh-users/zsh-autosuggestions \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."

  git clone \
    https://github.com/zsh-users/zsh-syntax-highlighting \
    "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# =============================================================================
# macOS defaults
# =============================================================================

echo "Applying macOS defaults..."

defaults write com.mitchellh.ghostty ApplePressAndHoldEnabled -bool false || true

# =============================================================================
# Done
# =============================================================================

echo ""
echo "================================="
echo "Dotfiles installed successfully"
echo "================================="
echo ""

echo "Restart your terminal or run:"
echo ""

echo "source ~/.zshrc"
