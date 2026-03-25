#!/bin/sh
# Utility for Helix: open the patch for the commit that last touched the current line.
# If the line isn't committed yet, it shows the working-tree diff for this file only.
# The script writes the diff to /tmp and prints the absolute path to stdout.
# Adjust `context` to see more or fewer unchanged lines around the change (default: 3).
#
# usage: blame_file_pretty.sh <file> <line> [context_lines]
# Helix mapping example:
# B = ':open %sh{ ~/.config/helix/utils/blame_file_pretty.sh "%{buffer_name}" %{cursor_line} 3 }'

file="$1"
line="$2"
ctx="${3:-3}"

# Blame the exact line.
porc="$(git blame -L "$line",+1 --porcelain -- "$file")" || exit 1
sha="$(printf '%s\n' "$porc" | awk 'NR==1{print $1}')"
commit_path="$(printf '%s\n' "$porc" | awk '/^filename /{print substr($0,10); exit}')"

out="/tmp/hx-blame_$(basename "$file")_${sha:-wt}.diff"

if [ -z "$sha" ] || [ "$sha" = 0000000000000000000000000000000000000000 ] || [ "$sha" = "^" ]; then
  # Uncommitted line -> working tree diff for this file.
  git --no-pager diff --no-color -U"$ctx" -- "$file" > "$out"
else
  # Committed line -> only this file's patch in that commit.
  git --no-pager show --no-color -M -C -U"$ctx" "$sha" -- "${commit_path:-$file}" > "$out"
fi

# Return the path for :open %sh{...}
printf '%s' "$out"
