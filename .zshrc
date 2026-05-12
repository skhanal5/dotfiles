# =============================================================================
# .zshrc
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="spaceship"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# GIT ALIASES
alias gds='git diff --staged'
alias gpf='git push --force-with-lease'
alias gplr='git pull --rebase'
alias grss='git restore --staged'
