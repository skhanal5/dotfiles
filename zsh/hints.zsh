# Habit tips.
# When you run a command that has a newer tool, print a short tip.
# The command still runs as normal.
#
# Add a tip with: DOTFILES_HINTS+=('<command>' '<tip>')
# The key is the first word, or the first two words (for example "git status").
# Aliases expand first, so a tip for "kubectl get" also shows for "k get".
# Remove a tip once the habit sticks.

typeset -gA DOTFILES_HINTS

_dotfiles_hint() {
  local -a words=(${(z)1})

  # Expand an alias in the first word. Then "k get" finds the "kubectl get" tip.
  (( ${+aliases[${words[1]}]} )) && words=(${(z)aliases[${words[1]}]} ${words[2,-1]})

  local tip=${DOTFILES_HINTS[${words[1]} ${words[2]}]:-${DOTFILES_HINTS[${words[1]}]}}

  [[ -n $tip ]] && print -r -- $'\e[2m'"tip: ${tip}"$'\e[0m' >&2
}

autoload -Uz add-zsh-hook
add-zsh-hook preexec _dotfiles_hint
