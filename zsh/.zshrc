# =============================================================================
# .zshrc
# =============================================================================


# =============================================================================
# Oh My Zsh
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source "$ZSH/oh-my-zsh.sh"



# =============================================================================
# Git aliases
# =============================================================================

alias gds='git diff --staged'
alias gpf='git push --force-with-lease'
alias gplr='git pull --rebase'
alias grss='git restore --staged'



# =============================================================================
# Autosuggestions
# =============================================================================

ZSH_AUTOSUGGEST_USE_ASYNC=1



# =============================================================================
# UV / Python
# =============================================================================

if command -v uv >/dev/null 2>&1; then
  eval "$(uv generate-shell-completion zsh)"
fi



# =============================================================================
# SDKMAN / Java
# =============================================================================

export SDKMAN_DIR="$HOME/.sdkman"

if [ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]; then
  source "$SDKMAN_DIR/bin/sdkman-init.sh"
fi



# =============================================================================
# Google Cloud SDK
# =============================================================================

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
fi

if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi



# =============================================================================
# opencode
# =============================================================================

if [ -d "$HOME/.opencode/bin" ]; then
  export PATH="$HOME/.opencode/bin:$PATH"
fi



# =============================================================================
# Go
# =============================================================================

if command -v go >/dev/null 2>&1; then
  export PATH="$PATH:$(go env GOPATH)/bin"
fi



# =============================================================================
# fnm / Node (optional)
# =============================================================================

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi



# =============================================================================
# fzf: Ctrl-R history, Ctrl-T files, Alt-C folders
# =============================================================================

if command -v fzf >/dev/null 2>&1; then
  # Use fd so search is fast, shows dotfiles, and skips .git
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

  source <(fzf --zsh)
fi
