# Onboarding: first run

Run this when no profile exists yet (see "Profiles" in SKILL.md), or when the user says
"start", "onboard me", "set me up" or "new site". It has four stages, in order. Tell the user
the stages up front in one line, so they know how long this takes, then go stage by stage.
Each stage ends with a short confirmation before moving on.

## Stage 1: Learn about the user and their channels

Ask in a few small rounds, not one long form. Use a question tool (like AskUserQuestion)
with options where one exists. Otherwise, ask in plain chat. Accept "skip" for anything optional.

**Round A: the business**
- Website URL (required)
- What the business does or sells, in one sentence
- Who it's for: audience, country/region, language(s)
- Business type: local business, ecommerce, SaaS, publisher/blog, agency, creator, other
- Main goal for the next 3 months: more traffic, more leads/sales, get cited by AI
  search, rank for specific keywords, fix a traffic drop

**Round B: the competition**
- 1-3 competitor websites they know of (optional; OpenSEO can find more later)
- 3-10 keywords or questions they want to be found for (optional)

**Round C: channels.** Each channel is optional. Ask which they have, then the link:
- YouTube channel URL
- Instagram, TikTok, LinkedIn (company or personal), X/Twitter, Facebook, Pinterest
- Google Business Profile (local businesses)
- Newsletter or podcast

Why channels matter: AI search engines and Google recognise a brand as one "entity" by
matching the website to its profiles (`sameAs` links in Organization schema, consistent
name and description). YouTube and Reddit are among the sources AI answers cite most.
Channels feed the audit's brand and entity checks; they are not audited as social accounts.

**Round D: the code**
- Where the site's code lives: a local folder path, a GitHub repo, or a hosted builder
  (Webflow, Wix, Shopify, WordPress, Squarespace). This decides how the fix workflow can
  apply changes. A hosted builder means the user gets copy-paste instructions, not edits.
- Do they own the site in Google Search Console? (yes / no / not sure)

Read the answers back as a short summary and ask "Anything to correct?" before saving.

## Stage 2: Save the profile

Write `~/.claudeseo/profiles/<domain>.md` (create the folder). Use exactly this layout so later
runs can read it:

```markdown
# <domain>
Updated: YYYY-MM-DD

## Business
- URL:
- Does / sells:
- Audience:
- Country / language:
- Type:
- 3-month goal:

## Competitors
-

## Target keywords
-

## Channels
| Channel | URL |
|---------|-----|

## Code
- Location:
- Search Console owner: yes | no | not sure

## Tools status
| Tool | Ready | Notes |
|------|-------|-------|

## Audit history
| Date | SEO Health | GEO Score | GEO Optimizer | Notes |
```

Never put keys, tokens or the contents of `client_secrets.json` in this file. A file path
is fine.

## Stage 3: Guided setup

Run `scripts/check_tools.sh` and show the result as a table. Then, for each tool that
isn't ready, follow `references/setup.md`. Handle the two logins carefully, because they're
where people get stuck:

**Google Search Console (GSC MCP).** Only if they own the site in Search Console. If
"no" or "not sure", explain how to check at https://search.google.com/search-console and
offer to skip for now. Then walk them through it one step at a time, waiting for "done"
after each:
1. Open https://console.cloud.google.com/ and create a project (any name, e.g. "claudeseo").
2. Open https://console.cloud.google.com/apis/library/searchconsole.googleapis.com and click
   **Enable**.
3. Open https://console.cloud.google.com/apis/credentials → **Create credentials** →
   **OAuth client ID**. If asked, configure the consent screen: External, app name, their
   email, and add themselves as a **test user**.
4. Application type **Desktop app** → Create → **Download JSON**.
5. Move it somewhere permanent, e.g. `~/Documents/client_secrets.json`, and send the
   **path only**. Never ask them to paste the file's contents.

Then register the server (setup.md step 4). The first Search Console call opens a browser
window; they sign in with the Google account that owns the site. Tell them that if Google
shows "app not verified", that's expected for a personal OAuth app: click Advanced →
Continue.

**OpenSEO.**
1. Make a free account at https://openseo.so (no card).
2. Install the plugin if missing (setup.md step 5).
3. In Claude Code, type `/mcp`, choose **openseo**, and sign in. The agent can't do this
   step for them.
4. Remind them: free credits are $0.50 (about 10 keyword lookups). You'll always ask
   before spending them.

If new commands or tools don't appear after installing, they need to restart the agent and
say "continue ClaudeSEO onboarding". The profile file lets you pick up where you stopped.

## Stage 4: Test the site (free, read-only)

Run one quick check per ready tool, nothing that spends credits:
- GEO Optimizer: `uvx --from geo-optimizer-skill geo audit --url <url>` → score
- GEO SEO Claude: `/geo quick <url>` → snapshot
- Claude SEO: `/seo doctor`, then `/seo page <url>` on the homepage
- GSC MCP: list properties, and confirm the site is there and the account can read it
- OpenSEO: confirm the connection works (account/project check only, no paid lookups)
- Channels: check the homepage links to the channels they gave, and whether Organization
  schema lists them in `sameAs`. Report what's missing.

Finish with:

| Tool | Ready | Test result | Still to do |

Then the three most important things the test showed, a line each. Update the profile's
"Tools status" and "Audit history". Offer the full audit next ("Run the full audit now?").
