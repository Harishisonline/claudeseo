#!/usr/bin/env bash
# ClaudeSEO status check: reports which of the five tools are installed.
# Read-only: installs nothing, prints no secrets.
set -u

ok()   { printf "  [ready]   %s\n" "$1"; }
miss() { printf "  [missing] %s -> %s\n" "$1" "$2"; }
todo() { printf "  [action]  %s -> %s\n" "$1" "$2"; }

echo "ClaudeSEO tool status"

have_claude=false
command -v claude >/dev/null 2>&1 && have_claude=true
plugins=""
$have_claude && plugins="$(claude plugin list 2>/dev/null)"

plugin_ok() { printf "%s" "$plugins" | grep -q "$1"; }

# 1. Claude SEO
if plugin_ok "claude-seo@"; then ok "Claude SEO (/seo)  - run /seo doctor if audits fail"
else miss "Claude SEO" "see references/setup.md step 1"; fi

# 2. GEO SEO Claude
if [ -f "$HOME/.claude/skills/geo/SKILL.md" ] && [ -x "$HOME/.claude/skills/geo/.venv/bin/python3" ]; then
  ok "GEO SEO Claude (/geo)"
else miss "GEO SEO Claude" "see references/setup.md step 2"; fi

# 3. GEO Optimizer
if command -v uvx >/dev/null 2>&1; then
  v="$(uvx --from geo-optimizer-skill geo --version 2>/dev/null | tail -1)"
  if [ -n "$v" ]; then ok "GEO Optimizer CLI ($v)"; else miss "GEO Optimizer CLI" "uvx --from geo-optimizer-skill geo --version failed"; fi
else miss "GEO Optimizer CLI" "install uv: https://docs.astral.sh/uv/"; fi
plugin_ok "geo-optimizer@" || todo "GEO Optimizer plugin" "optional: claude plugin install geo-optimizer@geoready"

# 4. GSC MCP
if $have_claude && claude mcp list 2>/dev/null | grep -qi "gscServer\|search-console"; then
  ok "GSC MCP (Search Console) - first call opens Google login if not yet authorized"
else todo "GSC MCP" "needs client_secrets.json path, see references/setup.md step 4"; fi

# 5. OpenSEO
if plugin_ok "openseo@"; then ok "OpenSEO plugin - sign in via /mcp -> openseo if tools are missing"
else miss "OpenSEO" "see references/setup.md step 5"; fi
