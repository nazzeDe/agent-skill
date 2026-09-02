#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
SRC_REPO="/home/nazze/Studio/oss/skills"
SRC_REF="custom"
BRANCH="upstream"
WT="$ROOT/.upstream"

# dest-name|path-under-skills）
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

if ! git -C "$SRC_REPO" show-ref --verify --quiet "refs/heads/$SRC_REF"; then
  echo "missing branch: $SRC_REPO $SRC_REF" >&2
  exit 1
fi

src_rev="$(git -C "$SRC_REPO" rev-parse --short "$SRC_REF")"

if ! git -C "$ROOT" show-ref --verify --quiet "refs/heads/$BRANCH"; then
  git -C "$ROOT" branch "$BRANCH"
fi
if [[ ! -d "$WT" ]]; then
  git -C "$ROOT" worktree add "$WT" "$BRANCH"
fi

old_rev="$(git -C "$WT" rev-parse HEAD)"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

paths=()
for item in "${ITEMS[@]}"; do
  dest="${item%%|*}"
  rel="${item#*|}"
  src_path="skills/$rel"
  if ! git -C "$SRC_REPO" cat-file -e "$SRC_REF:$src_path" 2>/dev/null; then
    echo "missing: $SRC_REF:$src_path" >&2
    exit 1
  fi
  rm -rf "$tmp/skills"
  git -C "$SRC_REPO" archive "$SRC_REF" "$src_path" | tar -x -C "$tmp"
  from="$tmp/$src_path"
  to="$WT/skills/$dest"
  mkdir -p "$to"
  if [[ -d "$from" ]]; then
    rm -rf "$to"
    mkdir -p "$to"
    cp -a "$from"/. "$to"/
    rm -rf "$to/agents"
  else
    cp -a "$from" "$to/$(basename "$from")"
  fi
  paths+=("skills/$dest")
  echo "sync $dest <- $SRC_REF:$src_path"
done

git -C "$WT" add -- "${paths[@]}"
if git -C "$WT" diff --cached --quiet; then
  echo "upstream already at $SRC_REF $src_rev"
else
  git -C "$WT" commit -m "sync skills from $SRC_REF $src_rev"
  echo "upstream $old_rev..$(git -C "$WT" rev-parse --short HEAD)"
  git -C "$WT" diff --stat "$old_rev" HEAD
fi

echo "next: git merge $BRANCH"
