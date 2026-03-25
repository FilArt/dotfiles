#!/bin/sh
# Utility function to use in Helix Editor to be able to see git hunks inline.
# Adjust `context` to a higher/lower number to see more/fewer lines of unmodified code
# before and after the modified lines (3 lines gives good context and is the default).
#
# usage: git-hunk.sh <file> <line> <context_lines>
# Helix mapping example:
# :run-shell-command ~/.config/helix/utils/git-hunk.sh %{buffer_name} %{cursor_line} 3

file="${1:-}"
line="${2:-}"
context="${3:-3}"

extract_hunk() {
  awk -v ln="$line" '
BEGIN { have=0; buf=""; out="" }
/^@@ /{
  if (have && out=="") { out=buf }
  buf = $0 ORS
  have = 0
  header = $0
  sub(/^.*\+/, "", header)
  sub(/ .*/, "", header)
  n = split(header, parts, ",")
  s = parts[1] + 0
  l = (n >= 2 ? parts[2] + 0 : 1)
  have = (l == 0 ? (ln == s) : (ln >= s && ln < s + l))
  next
}
{ if (buf != "") buf = buf $0 ORS }
END {
  if (have && out=="") out=buf
  if (out != "") print out
}
'
}

if [ -z "$file" ] || [ -z "$line" ]; then
  printf 'Usage: git-hunk.sh <file> <line> [context_lines]\n'
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

staged_hunk="$(git --no-pager diff --cached --no-color -U"$context" -- "$repo_file" | extract_hunk)"
unstaged_hunk="$(git --no-pager diff --no-color -U"$context" -- "$repo_file" | extract_hunk)"

if [ -n "$staged_hunk" ]; then
  printf '=== staged hunk: %s ===\n%s' "$repo_file" "$staged_hunk"
fi

if [ -n "$staged_hunk" ] && [ -n "$unstaged_hunk" ]; then
  printf '\n'
fi

if [ -n "$unstaged_hunk" ]; then
  printf '=== unstaged hunk: %s ===\n%s' "$repo_file" "$unstaged_hunk"
fi

if [ -z "$staged_hunk" ] && [ -z "$unstaged_hunk" ]; then
  printf 'No hunk under cursor\n'
fi
