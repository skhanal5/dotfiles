# =============================================================================
# .zshrc
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"


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

# =============================================================================
# .zshrc
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster"

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

# AUTOSUGGESTIONS
ZSH_AUTOSUGGEST_USE_ASYNC=1

# UV
eval "$(uv generate-shell-completion zsh)"

# SDKMAN — must be at end of file
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# GOOGLE CLOUD SDK
if [ -f '/Users/subodh/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/subodh/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/subodh/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/subodh/google-cloud-sdk/completion.zsh.inc'; fi
