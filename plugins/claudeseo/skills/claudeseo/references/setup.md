# Setup: install and verify the five tools

Goal: every tool installed and tested, and the user asked only for what you can't do
yourself (logins, keys, their website URL). Run `scripts/check_tools.sh` first and
install only what's missing.

Before installing anything, read each repo's README. If it differs from the steps below,
follow the README: these projects change often. Show each command before running it.
If one tool fails, skip it, keep going, and explain why at the end.

Prerequisites: git, Python 3.10+, `uv`/`uvx` (install from https://docs.astral.sh/uv/ if
missing) and the `claude` CLI for the plugin commands.

## 1. Claude SEO: https://github.com/AgriciDaniel/claude-seo

```bash
claude plugin marketplace add AgriciDaniel/claude-seo
claude plugin install claude-seo@agricidaniel-claude-seo
```
Then inside Claude Code: `/seo setup` (builds its own Python env + headless Chromium),
and check it with `/seo doctor`. Note for the user: it adds a PostToolUse hook that
validates JSON-LD after edits to web files (.html, .tsx, .vue…).

## 2. GEO SEO Claude: https://github.com/zubair-trabzada/geo-seo-claude

```bash
git clone --depth 1 https://github.com/zubair-trabzada/geo-seo-claude.git
cd geo-seo-claude && ./install.sh        # Windows: ./install-win.sh from Git Bash
```
Installs to `~/.claude/skills/geo` + `geo-*` skills + `geo-*` agents, Python deps in
`~/.claude/skills/geo/.venv`. Optional screenshots:
`~/.claude/skills/geo/.venv/bin/python3 -m playwright install chromium`.

## 3. GEO Optimizer: https://github.com/Auriti-Labs/geo-optimizer-skill

```bash
claude plugin marketplace add Auriti-Labs/geo-optimizer-skill
claude plugin install geo-optimizer@geoready
uvx --from geo-optimizer-skill geo --version     # the CLI the skill needs
```

## 4. GSC MCP: https://github.com/AminForou/mcp-gsc

Walk the user through OAuth step by step. They must use the Google account that owns
the site in Search Console:
1. Google Cloud Console → create/select a project.
2. Enable the Search Console API.
3. Credentials → Create credentials → OAuth client ID → configure consent screen →
   **Desktop app** → Create.
4. Download the JSON, save it somewhere permanent (e.g. `~/Documents/client_secrets.json`).
5. Ask for the **path only**, never the contents.

```bash
claude mcp add -s user gscServer \
  -e GSC_OAUTH_CLIENT_SECRETS_FILE=/full/path/to/client_secrets.json \
  -- "$(which uvx)" mcp-search-console
```
Use the full path to uvx. It's read-only by default; never set `GSC_ALLOW_DESTRUCTIVE`.
The first call opens a browser for the Google login.

## 5. OpenSEO: https://github.com/every-app/open-seo

User makes a free account at https://openseo.so (no card). Then:
```bash
claude plugin marketplace add every-app/open-seo
claude plugin install openseo@openseo       # adds MCP server + 12 openseo:* skills
```
Other agents: add the HTTP MCP server `https://app.openseo.so/mcp`. The user logs in via
`/mcp` → openseo. Rank checks need the paid plan ($10/month). Warn before anything uses
credits.

## Finish

Ask for the website URL, run one quick, free test per tool (e.g. `geo audit --url`,
`/geo quick`, a GSC `list_properties`, an OpenSEO account/project check, `/seo doctor`),
then give a table:

| Tool | Installed | Test result | What the user still needs to do |

Remind them to restart the agent if new commands don't show up.
