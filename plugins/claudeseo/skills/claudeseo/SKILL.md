---
name: claudeseo
description: One-stop SEO + GEO (AI search) team for any website, built on five free tools - Claude SEO (/seo), GEO SEO Claude (/geo), GEO Optimizer (geo CLI), GSC MCP (Google Search Console data) and OpenSEO (keywords, competitors, backlinks). First run onboards the user (business, website, YouTube and social channels), walks them through Search Console and OpenSEO setup, and tests the site. Then runs a read-only audit that merges every tool into one ranked SEO-AUDIT.md, and a fix workflow that applies it to the site's code and re-scores. Use this whenever the user wants an SEO audit, asks why a site isn't ranking or isn't cited by ChatGPT, Perplexity or Google AI Overviews, wants to set up SEO tools, mentions SEO-AUDIT.md, low CTR, page-2 rankings, llms.txt, robots.txt for AI crawlers, schema or Search Console, or says "ClaudeSEO" - even if they don't name a specific tool.
---

# ClaudeSEO

Five free tools, four workflows. The tools overlap on purpose: each sees the site
differently (crawl, AI-search readiness score, real Google data, competitor data). The
value comes from merging them into one ranked list of fixes backed by evidence, tailored to
the user's business.

| # | Tool | How to call it | What it gives |
|---|------|----------------|---------------|
| 1 | Claude SEO | `/seo audit <url>` (skill `claude-seo:seo-audit`) | Full SEO audit, SEO Health Score 0-100 |
| 2 | GEO SEO Claude | `/geo audit <url>` (skill `geo-audit`) | AI-search visibility, GEO Score 0-100 |
| 3 | GEO Optimizer | `uvx --from geo-optimizer-skill geo audit --url <url>` (or `geo-optimizer` MCP tools) | AI-readiness score 0-100, `geo fix` previews |
| 4 | GSC MCP | `gscServer` MCP tools | Real Search Console clicks, impressions, CTR, positions, indexing |
| 5 | OpenSEO | `openseo` MCP tools / `openseo:*` skills | Competitors, keyword gaps, backlinks (uses paid credits) |

If the agent has no slash commands, use the matching skill or MCP tool instead.

**Bundled edition:** if a `tools/` folder sits next to this file, the first four tools'
instructions and scripts are inside this skill. Use them whenever the installed tools are
missing (Cowork, claude.ai, sandboxes): read `references/bundled-tools.md` first. It maps
every path and command the tools expect to its bundled location.

## Profiles

Each site the user works on has a profile at `~/.claudeseo/profiles/<domain>.md`. It
holds the business, goals, competitors, channels, code location, tool status and audit
history. Read it at the start of every workflow, so you don't re-ask what you already know
and the audit can rank fixes against the user's actual goal. Update it at the end.

## Pick the workflow

- **Onboarding**: no profile exists yet, or the user says start / onboard / set me up /
  new site → read `references/onboarding.md`. It interviews the user, guides the Search
  Console and OpenSEO setup, and tests the site.
- **Setup only**: a tool is missing or broken, or the user asks to install or check the tools →
  `references/setup.md`.
- **Audit**: "audit", "why am I not ranking", "check my site" → `references/audit.md`.
  Read-only: never edits files.
- **Fix**: "fix", "apply the audit", or `SEO-AUDIT.md` exists and the working folder is the
  site's code → `references/fixes.md`.

If the user asks for an audit but there's no profile, offer the short onboarding first
(about 5 minutes). If they decline, ask only for the URL and go.

## Always start with a status check

```bash
bash <this skill's folder>/scripts/check_tools.sh
```

It reports which of the five tools are installed and which still need a login. A tool that
isn't ready is not a blocker: skip it, keep going, and say at the top of the result which
tool didn't run and why. A report that silently omits a tool reads as "no problems found",
which is the wrong conclusion. In the bundled edition, a tool the script reports missing
usually has a bundled copy: use that before skipping it.

## Ground rules (why they exist)

- **Only real findings.** Every item needs proof: a number, a URL or a tool's output. SEO
  advice without evidence is the generic advice the user could get anywhere.
- **Credits cost money.** OpenSEO's free plan is 500 credits (50 US cents). For example,
  metrics for 8 keywords cost about 15 credits, and a page-1 Google check costs about 5 per keyword.
  Check the balance with the free `whoami` tool before and after, and report what was used.
  State the expected cost and get a yes before any call that spends credits. Search
  Console data and saved OpenSEO results are free.
- **Secrets stay secret.** Never print, paste, save to a profile or commit
  `client_secrets.json`, OAuth tokens or API keys. Refer to them by path only.
- **Show before running.** Show each install command before running it, and read any
  install script before executing it.
- **The user deploys.** Never deploy, delete pages, change URLs or remove content without
  asking. Never invent facts, reviews or stats for their content.

## Output files

- `~/.claudeseo/profiles/<domain>.md`: the site profile (layout in `references/onboarding.md`).
- `SEO-AUDIT.md` in the current folder: written by the audit, updated by the fix
  workflow. Keep the layout in `references/audit.md` so later runs can read it.
