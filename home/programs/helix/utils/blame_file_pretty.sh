#!/bin/sh
# Utility for Helix: open the patch for the commit that last touched the current line.
# If the line isn't committed yet, it shows the working-tree diff for this file only.
# The script writes the diff to /tmp and prints the absolute path to stdout.
# Adjust `context` to see more or fewer unchanged lines around the change (default: 3).
#
# usage: blame_file_pretty.sh <file> <line> [context_lines]
# Helix mapping example:
# B = ':open %sh{ ~/.config/helix/utils/blame_file_pretty.sh "%{buffer_name}" %{cursor_line} 3 }'

file="${1:-}"
line="${2:-}"
ctx="${3:-3}"

new_output() {
  mktemp /tmp/hx-blame-file.XXXXXX
}

write_message() {
  out="$(new_output)"
  printf '%s\n' "$1" > "$out"
  printf '%s' "$out"
  exit 0
}

if [ -z "$file" ] || [ -z "$line" ]; then
  write_message "Usage: blame_file_pretty.sh <file> <line> [context_lines]"
fi

file_dir="$(dirname -- "$file")"
repo_root="$(git -C "$file_dir" rev-parse --show-toplevel 2>/dev/null)" ||
  write_message "Not inside a git repository: $file"

abs_file="$(realpath "$file" 2>/dev/null || printf '%s' "$file")"
repo_file="$(realpath --relative-to="$repo_root" "$abs_file" 2>/dev/null || printf '%s' "${abs_file#$repo_root/}")"

cd "$repo_root" || exit 1

out="$(new_output)"

if ! git ls-files --error-unmatch -- "$repo_file" >/dev/null 2>&1; then
  printf 'Untracked file: %s\n\nNo commit diff is available yet.\n' "$repo_file" > "$out"
  printf '%s' "$out"
  exit 0
fi

porc="$(git blame -L "$line",+1 --porcelain -- "$repo_file" 2>/dev/null || true)"
sha="$(printf '%s\n' "$porc" | awk 'NR==1{print $1}')"
commit_path="$(printf '%s\n' "$porc" | awk '/^filename /{print substr($0,10); exit}')"

if [ -z "$sha" ] || [ "$sha" = 0000000000000000000000000000000000000000 ] || [ "$sha" = "^" ]; then
  wrote=0

  if ! git diff --cached --quiet -- "$repo_file"; then
    printf '=== staged changes: %s ===\n' "$repo_file" > "$out"
    git --no-pager diff --cached --no-color -U"$ctx" -- "$repo_file" >> "$out"
    wrote=1
  fi

  if ! git diff --quiet -- "$repo_file"; then
    if [ "$wrote" -eq 1 ]; then
      printf '\n' >> "$out"
    fi
    printf '=== unstaged changes: %s ===\n' "$repo_file" >> "$out"
    git --no-pager diff --no-color -U"$ctx" -- "$repo_file" >> "$out"
    wrote=1
  fi

  if [ "$wrote" -eq 0 ]; then
    printf 'No staged or unstaged diff available for %s\n' "$repo_file" > "$out"
  fi
else
  git --no-pager show --no-color -M -C -U"$ctx" "$sha" -- "${commit_path:-$repo_file}" > "$out"
  if [ ! -s "$out" ]; then
    printf 'No patch available for %s at %s\n' "$repo_file" "$sha" > "$out"
  fi
fi

# Return the path for :open %sh{...}
printf '%s' "$out"
