#!/usr/bin/env bash
set -euo pipefail

SRC="/home/nazze/Studio/oss/skills"
DST="$(cd "$(dirname "$0")" && pwd)/skills"

# dest-name|path-under-skills
ITEMS=(
  "code-review|engineering/code-review"
  "codebase-design|engineering/codebase-design"
  "diagnosing-bugs|engineering/diagnosing-bugs"
  "implement|engineering/implement"
  "prototype|engineering/prototype"
  "tdd|engineering/tdd"
  "to-spec|engineering/to-spec"
  "to-tickets|engineering/to-tickets"
  "handoff|productivity/handoff"
  "to-questionnaire|productivity/to-questionnaire"
)

if [[ "$(git -C "$SRC" branch --show-current)" != custom ]]; then
  echo "checkout custom in $SRC first" >&2
  exit 1
fi

for item in "${ITEMS[@]}"; do
  dest="${item%%|*}"
  rel="${item#*|}"
  from="$SRC/skills/$rel"
  to="$DST/$dest"
  if [[ ! -d "$from" ]]; then
    echo "missing: $from" >&2
    exit 1
  fi
  if [[ -L "$to" ]]; then
    rm "$to"
  fi
  mkdir -p "$to"
  while IFS= read -r -d '' f; do
    r="${f#"$from/"}"
    case "$r" in
      agents|agents/*) continue ;;
    esac
    d="$to/$r"
    mkdir -p "$(dirname "$d")"
    ln -f "$f" "$d"
    echo "link $dest/$r"
  done < <(find "$from" -type f -print0)
done
