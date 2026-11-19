# ClaudeSEO

One Claude Code skill that runs a full SEO + AI-search (GEO) team on your website, built on five
free, open-source tools. It learns about your business and channels, walks you through the setup,
tests your site, then gives you one ranked list of fixes and can apply them to your code.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Harish%20Pradhan-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/in/harishpradhan0131/)
[![GitHub](https://img.shields.io/badge/GitHub-Harishisonline-181717?logo=github&logoColor=white)](https://github.com/Harishisonline)

## Install

In Claude Code:

```bash
claude plugin marketplace add Harishisonline/claudeseo
claude plugin install claudeseo@claudeseo
```

Restart Claude Code, then say:

```
Start ClaudeSEO
```

## What happens on first run

1. **Learns about you.** Your website, what you sell, your audience and goal, competitors,
   target keywords, your YouTube and social channels, and where your site's code lives. It's saved
   to `~/.claudeseo/profiles/<your-domain>.md` so you're never asked twice.
2. **Guided setup.** It installs the five tools, showing each command first, and walks you through
   the two logins step by step:
   - Google Search Console: creating `client_secrets.json` in Google Cloud.
   - OpenSEO: a free account and the `/mcp` sign-in.
3. **Tests your site.** One free, read-only check per tool, then a status table and the three
   biggest issues it found.

## Then, any time

| Say | What it does |
|-----|--------------|
| `Audit https://yoursite.com` | Read-only. Runs every tool and writes one ranked `SEO-AUDIT.md`, each fix with proof and effort. |
| `Fix the SEO audit` (in your site's code folder) | Shows the plan, waits for one OK, applies the fixes, re-scores before → after. |
| `Check my SEO tools` | Status of all five tools. |

## The five tools

| Tool | What it adds | Cost |
|------|--------------|------|
| [Claude SEO](https://github.com/AgriciDaniel/claude-seo) | Full SEO audit, prioritized action plan | Free |
| [GEO SEO Claude](https://github.com/zubair-trabzada/geo-seo-claude) | Can ChatGPT, Perplexity and Google AI find and cite you? | Free |
| [GEO Optimizer](https://github.com/Auriti-Labs/geo-optimizer-skill) | AI-search readiness score 0-100 + robots.txt, llms.txt, schema fixes | Free |
| [GSC MCP](https://github.com/AminForou/mcp-gsc) | Your real Google Search Console data (read-only) | Free |
| [OpenSEO](https://github.com/every-app/open-seo) | Keywords, competitors, backlinks | Free $0.50 credits; asks before spending |

## Safety

- Audits are read-only. Fixes need your OK, and it never deploys, deletes pages or changes URLs.
- Keys and `client_secrets.json` are referred to by path only: never printed, saved or committed.
- No invented facts, reviews or stats. Every finding cites a tool result.

## Requirements

Claude Code, git, Python 3.10+ and [uv](https://docs.astral.sh/uv/). Works on macOS and Linux;
on Windows, use Git Bash.

## Credits

ClaudeSEO is a guide and orchestrator. The five tools above belong to their authors and keep their
own licenses. ClaudeSEO itself is MIT licensed.

---

Built by **Harish Pradhan**: [LinkedIn](https://www.linkedin.com/in/harishpradhan0131/) · [GitHub](https://github.com/Harishisonline)
