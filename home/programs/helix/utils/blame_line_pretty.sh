#!/bin/sh
# Utility for Helix: pretty-print blame info for the line under the cursor.
# Quite basic.
#
# usage: blame_line_pretty.sh <file> <line>
# Helix mapping example:
# b = ":run-shell-command ~/.config/helix/utils/blame_line_pretty.sh %{buffer_name} %{cursor_line}"

file="${1:-}"
line="${2:-}"

if [ -z "$file" ] || [ -z "$line" ]; then
  printf 'Usage: blame_line_pretty.sh <file> <line>\n'
  exit 0
fi

file_dir="$(dirname -- "$file")"
repo_root="$(git -C "$file_dir" rev-parse --show-toplevel 2>/dev/null)" || {
  printf 'Not inside a git repository: %s\n' "$file"
  exit 0
}

abs_file="$(realpath "$file" 2>/dev/null || printf '%s' "$file")"
repo_file="$(realpath --relative-to="$repo_root" "$abs_file" 2>/dev/null || printf '%s' "${abs_file#$repo_root/}")"

cd "$repo_root" || exit 1

if ! git ls-files --error-unmatch -- "$repo_file" >/dev/null 2>&1; then
  printf 'Untracked file: %s\n' "$repo_file"
  exit 0
fi

out="$(git blame -L "$line",+1 --porcelain -- "$repo_file" 2>/dev/null || true)"

sha="$(printf '%s\n' "$out" | awk 'NR==1{print $1}')"
author="$(printf '%s\n' "$out" | awk -F'author ' '/^author /{print $2; exit}')"
epoch="$(printf '%s\n' "$out" | awk '/^author-time /{print $2; exit}')"
summary="$(printf '%s\n' "$out" | awk -F'summary ' '/^summary /{print $2; exit}')"
change="$(printf '%s\n' "$out" | tail -n 1)"

if [ -z "$sha" ] || [ "$sha" = 0000000000000000000000000000000000000000 ] || [ "$sha" = "^" ]; then
  staged="no"
  unstaged="no"

  if ! git diff --cached --quiet -- "$repo_file"; then
    staged="yes"
  fi

  if ! git diff --quiet -- "$repo_file"; then
    unstaged="yes"
  fi

  printf 'uncommitted\n%s\nstaged: %s\nunstaged: %s\n' "$repo_file" "$staged" "$unstaged"
  exit 0
fi

# dd-mm-yyyy (macOS `date -r`; fallback to gdate if present)
date="$(
  (date -r "$epoch" +%d-%m-%Y\ %H:%M 2>/dev/null) ||
    (gdate -d "@$epoch" +%d-%m-%Y\ %H:%M 2>/dev/null) ||
    printf '%s' "$epoch"
)"

printf "%s\n%s\n%s\n%s\n%s\n" "$sha" "$author" "$date" "$summary" "$change"
