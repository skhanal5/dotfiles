# =============================================================================
# .zshrc
# =============================================================================


# =============================================================================
# Oh My Zsh
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

# Starship draws the prompt (see the end of this file)
ZSH_THEME=""

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  you-should-use
  kubectl
)

source "$ZSH/oh-my-zsh.sh"



# =============================================================================
# Habit tips (see zsh/hints.zsh)
# =============================================================================

# Find this repo through the ~/.zshrc link
DOTFILES_ZSH="${${(%):-%x}:A:h}"

source "$DOTFILES_ZSH/hints.zsh"



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
# mise: Java and Node versions (see mise/config.toml)
# =============================================================================

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"

  DOTFILES_HINTS+=(
    sdk 'SDKMAN is gone. Use mise use java@<version> or edit mise/config.toml.'
    fnm 'fnm is gone. Use mise use node@<version> or edit mise/config.toml.'
  )
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
# fzf: Ctrl-R history, Ctrl-T files, Alt-C folders
# =============================================================================

if command -v fzf >/dev/null 2>&1; then
  # Use fd so search is fast, shows dotfiles, and skips .git
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

  source <(fzf --zsh)
fi



# =============================================================================
# zoxide: "z <part of name>" jumps to a folder you visited before
# =============================================================================

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"

  DOTFILES_HINTS+=(cd 'z <part of name> jumps to a folder. zi picks one with fzf.')
fi



# =============================================================================
# eza and bat: better ls and cat. The old commands still work.
# =============================================================================

if command -v eza >/dev/null 2>&1; then
  alias ll='eza -l --git --icons=auto'
  alias la='eza -la --git --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'

  DOTFILES_HINTS+=(
    ls   'll shows details and git status. la adds hidden files. lt shows a tree.'
    tree 'lt shows a tree with icons.'
  )
fi

if command -v bat >/dev/null 2>&1; then
  DOTFILES_HINTS+=(cat 'bat <file> shows syntax colors and line numbers.')
fi



# =============================================================================
# Kubernetes: the kubectl plugin above adds "k" and short aliases
# =============================================================================

if command -v k9s >/dev/null 2>&1; then
  DOTFILES_HINTS+=(
    'kubectl get'      'k9s shows live resources. Type : and a kind, such as :pods.'
    'kubectl describe' 'k9s shows details. Select a row and press d.'
    'kubectl logs'     'k9s shows logs. Select a pod and press l.'
    'kubectl config'   'kubectx switches context. kubens switches namespace.'
  )
fi



# =============================================================================
# lazygit: a terminal UI for staging, commits, and branches
# =============================================================================

if command -v lazygit >/dev/null 2>&1; then
  alias lg='lazygit'

  DOTFILES_HINTS+=(
    'git add' 'lg opens lazygit. Press space to stage a file and c to commit.'
    'git log' 'lg opens lazygit. Press 4 for the commit list.'
  )
fi



# =============================================================================
# direnv: load a folder's .envrc when you cd into it
# =============================================================================

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"

  DOTFILES_HINTS+=(export 'put project env vars in .envrc, then run direnv allow.')
fi



# =============================================================================
# Starship prompt. Keep this last so it wraps everything above.
# =============================================================================

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
