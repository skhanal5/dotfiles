# Habit tips.
# When you run a command that has a newer tool, print a short tip.
# The command still runs as normal.
#
# Add a tip with: DOTFILES_HINTS+=('<command>' '<tip>')
# The key is the first word, or the first two words (for example "git status").
# Remove a tip once the habit sticks.

typeset -gA DOTFILES_HINTS

_dotfiles_hint() {
  local -a words=(${(z)1})
  local tip=${DOTFILES_HINTS[${words[1]} ${words[2]}]:-${DOTFILES_HINTS[${words[1]}]}}

  [[ -n $tip ]] && print -r -- $'\e[2m'"tip: ${tip}"$'\e[0m' >&2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _dotfiles_hint
