#!/bin/bash
# Claude Code status line: model · N% ctx · dir · git branch
# Reads session JSON on stdin. Prints one line. Omits any missing segment.

input=$(cat)

JQ=$(command -v jq 2>/dev/null || true)
[ -z "$JQ" ] && [ -x /usr/bin/jq ] && JQ=/usr/bin/jq
[ -z "$JQ" ] && exit 0

model=$(printf '%s' "$input" | "$JQ" -r '.model.display_name // empty' 2>/dev/null)
used=$(printf '%s' "$input" | "$JQ" -r '.context_window.used_percentage // empty' 2>/dev/null)
dir=$(printf '%s' "$input" | "$JQ" -r '.workspace.current_dir // .cwd // empty' 2>/dev/null)

# Colors only when allowed. Plain text otherwise.
if [ -z "${NO_COLOR:-}" ] && [ "${TERM:-dumb}" != "dumb" ]; then
  C_DIM=$'\033[2m'; C_CYAN=$'\033[36m'; C_BLUE=$'\033[34m'; C_GREEN=$'\033[32m'; C_RST=$'\033[0m'
else
  C_DIM=""; C_CYAN=""; C_BLUE=""; C_GREEN=""; C_RST=""
fi

segs=()

[ -n "$model" ] && segs+=("${C_CYAN}${model}${C_RST}")

if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used" 2>/dev/null)
  [ -n "$pct" ] && segs+=("${C_DIM}${pct}% ctx${C_RST}")
fi

if [ -n "$dir" ]; then
  segs+=("${C_BLUE}$(basename "$dir")${C_RST}")
  branch=""
  if [ -d "$dir" ] && [ "$(git --no-optional-locks -C "$dir" rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
    branch=$(git --no-optional-locks -C "$dir" symbolic-ref --short -q HEAD 2>/dev/null)
    [ -z "$branch" ] && branch=$(git --no-optional-locks -C "$dir" rev-parse --short HEAD 2>/dev/null)
  fi
  [ -n "$branch" ] && segs+=("${C_GREEN}${branch}${C_RST}")
fi

out=""
sep=" ${C_DIM}·${C_RST} "
for s in "${segs[@]}"; do
  if [ -z "$out" ]; then out="$s"; else out="${out}${sep}${s}"; fi
done

printf '%s\n' "$out"
