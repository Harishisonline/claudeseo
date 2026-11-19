# Bundled edition: using the tools inside this skill

The bundled edition of ClaudeSEO ships a `tools/` folder next to SKILL.md. Use it when
the installed tools aren't available, as in Cowork, claude.ai, or any sandbox where
`check_tools.sh` reports them missing. Installed tools win when both exist: they're the
authors' real setup.

`tools/THIRD_PARTY.md` lists each project, its pinned commit and its license. Credit the
original project when you report its findings ("GEO SEO Claude found…").

Each tool's own skill files are renamed `INSTRUCTIONS.md`. When one tool's instructions
say "load the X skill" or "use the X sub-skill", open `tools/<tool>/skills/X/INSTRUCTIONS.md`.
Its `agents/*.md` files are briefs for subagents; with no subagents, follow them yourself,
one at a time.

Below, `$SKILL` means this skill's folder (the one holding SKILL.md).

## Map: what each tool's instructions assume, and the bundled path

| Tool | Their instructions say | Use instead |
|------|-------------------------|-------------|
| Claude SEO | `${CLAUDE_PLUGIN_ROOT}/...` | `$SKILL/tools/claude-seo/...` |
| Claude SEO | `/seo audit`, `/seo page`, … | `tools/claude-seo/skills/seo/INSTRUCTIONS.md` (router), then the sub-skill it names |
| GEO SEO Claude | `~/.claude/skills/geo/...` | `$SKILL/tools/geo-seo-claude/geo/...`; its `scripts/`, `schema/` and `templates/` sit in `tools/geo-seo-claude/` |
| GEO SEO Claude | `/geo audit`, `/geo quick`, … | `tools/geo-seo-claude/geo/INSTRUCTIONS.md`, then `skills/geo-*/INSTRUCTIONS.md` |
| GEO Optimizer | the `geo` CLI | `pip install geo-optimizer-skill` (or `uvx --from geo-optimizer-skill geo …`); guide in `tools/geo-optimizer/INSTRUCTIONS.md` |
| OpenSEO | `openseo:*` skills + MCP tools | `tools/openseo/skills/*/INSTRUCTIONS.md`; the data still comes from the OpenSEO **connector** |
| GSC MCP | `gscServer` MCP tools | Not bundleable (a local server). Use OpenSEO's Search Console tools if the user connected Search Console in OpenSEO, otherwise skip and say so |

## One-time Python setup (per sandbox)

The scripts need Python 3.10+ and a few packages. Install them once, quietly, and only when a
script is about to run:

```bash
cd "$SKILL/tools"
python3 -m pip install -q -r claude-seo/requirements.txt -r geo-seo-claude/requirements.txt
python3 -m pip install -q geo-optimizer-skill
```

Claude SEO's launcher needs two environment variables. Set them in the same shell command
as the call:

```bash
export CLAUDE_PLUGIN_ROOT="$SKILL/tools/claude-seo" CLAUDE_PLUGIN_DATA="$HOME/.claudeseo/claude-seo-data"
bash "$CLAUDE_PLUGIN_ROOT/scripts/claude-seo" setup     # once
bash "$CLAUDE_PLUGIN_ROOT/scripts/claude-seo" run fetch_page.py https://example.com
```

GEO SEO Claude's scripts run directly: `python3 "$SKILL/tools/geo-seo-claude/scripts/<name>.py"`.

## When something can't run

Sandboxes may block the network to some sites, lack a headless browser (screenshots,
visual and Core Web Vitals lab checks), or forbid `pip install`. Run what works, then
list what didn't run and why at the top of the result. A partial audit that says what it
skipped is useful; a silent gap reads as "no problems found".
