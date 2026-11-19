#!/usr/bin/env bash
# Builds the bundled edition of ClaudeSEO (for Cowork / claude.ai, where the
# five tools can't be installed as plugins). It copies each MIT-licensed tool's
# skills, agents and scripts, at the pinned commits below, into tools/ inside
# the skill, with their licenses and a THIRD_PARTY.md credits file.
#
# Usage: bash bundle/build.sh            -> dist/claudeseo/ and dist/claudeseo.skill
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_SKILL="$ROOT/plugins/claudeseo/skills/claudeseo"
DIST="$ROOT/dist"
OUT="$DIST/claudeseo"
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

# repo | pinned commit
TOOLS=(
  "AgriciDaniel/claude-seo|468ed5b0d9e3"
  "zubair-trabzada/geo-seo-claude|989cae01e8eb"
  "Auriti-Labs/geo-optimizer-skill|d79ba15fede7"
  "every-app/open-seo|672a66cef810"
)

fetch() {  # fetch <owner/repo> <commit> -> $WORK/<repo>
  local repo="$1" sha="$2" dir="$WORK/$(basename "$1")"
  git init -q "$dir"
  git -C "$dir" remote add origin "https://github.com/$repo.git"
  git -C "$dir" fetch -q --depth 1 origin "$sha" 2>/dev/null \
    || git -C "$dir" fetch -q origin   # some hosts refuse fetch-by-short-sha
  git -C "$dir" checkout -q "$sha"
  git -C "$dir" rev-parse HEAD
}

rm -rf "$OUT" && mkdir -p "$OUT/tools"
cp -R "$SRC_SKILL/." "$OUT/"

credits="$OUT/tools/THIRD_PARTY.md"
{
  echo "# Bundled tools"
  echo
  echo "ClaudeSEO's bundled edition includes these MIT-licensed projects, unmodified except"
  echo "that each nested SKILL.md is renamed INSTRUCTIONS.md so only ClaudeSEO registers as"
  echo "a skill. Each folder keeps its original LICENSE. All credit goes to their authors."
  echo
  echo "| Folder | Project | Commit |"
  echo "|--------|---------|--------|"
} > "$credits"

for entry in "${TOOLS[@]}"; do
  repo="${entry%%|*}"; sha="${entry##*|}"
  full_sha="$(fetch "$repo" "$sha")"
  src="$WORK/$(basename "$repo")"
  case "$repo" in
    AgriciDaniel/claude-seo)
      dest="$OUT/tools/claude-seo"; mkdir -p "$dest"
      cp -R "$src/skills" "$src/agents" "$src/scripts" "$src/data" "$src/schema" "$dest/"
      cp "$src/requirements.txt" "$src/pyproject.toml" "$dest/" ;;
    zubair-trabzada/geo-seo-claude)
      dest="$OUT/tools/geo-seo-claude"; mkdir -p "$dest"
      cp -R "$src/geo" "$src/skills" "$src/agents" "$src/scripts" "$src/schema" "$src/templates" "$dest/"
      cp "$src/requirements.txt" "$dest/" ;;
    Auriti-Labs/geo-optimizer-skill)
      dest="$OUT/tools/geo-optimizer"; mkdir -p "$dest"
      cp "$src/SKILL.md" "$dest/"
      cp -R "$src/references" "$dest/" ;;
    every-app/open-seo)
      dest="$OUT/tools/openseo"; mkdir -p "$dest"
      cp -R "$src/plugins/openseo/skills" "$dest/" ;;
  esac
  cp "$src/LICENSE" "$dest/LICENSE"
  echo "| \`tools/$(basename "$dest")\` | [$repo](https://github.com/$repo) | \`${full_sha:0:12}\` |" >> "$credits"
done

# Only the top-level SKILL.md may register as a skill.
find "$OUT/tools" -name SKILL.md -execdir mv SKILL.md INSTRUCTIONS.md \;
find "$OUT" -name '__pycache__' -prune -exec rm -rf {} + ; find "$OUT" -name '.DS_Store' -delete

echo "Built $OUT ($(du -sh "$OUT" | cut -f1), $(find "$OUT" -type f | wc -l | tr -d ' ') files)"

# Package as .skill (a zip whose top folder is the skill name).
rm -f "$DIST/claudeseo.skill"
( cd "$DIST" && zip -qr -X claudeseo.skill claudeseo )
echo "Packaged $DIST/claudeseo.skill ($(du -h "$DIST/claudeseo.skill" | cut -f1))"
