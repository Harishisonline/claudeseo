# Audit: one ranked list from every tool (read-only)

Audit the site for Google SEO and AI search (ChatGPT, Perplexity, Google AI Overviews).
Change nothing: no file edits, no `geo fix --apply`.

Need: the site URL. Read the profile (`~/.claudeseo/profiles/<domain>.md`) if it exists:
its competitors and target keywords go into step 5, and its 3-month goal decides what
counts as "impact" when ranking. Run `scripts/check_tools.sh`, then run every tool that's ready. The
tools are independent, so start the slow ones (`/seo audit`, `/geo audit`) in parallel
where the agent allows.

1. **Claude SEO**: `/seo audit <url>`. Note the SEO Health Score.
2. **GEO SEO Claude**: `/geo audit <url>`. Note the GEO Score.
3. **GEO Optimizer**: `uvx --from geo-optimizer-skill geo audit --url <url>`. Note the
   0-100 score.
4. **GSC MCP**, last 90 days (match the property to the URL: `sc-domain:` or the URL prefix):
   - queries with many impressions but CTR far below normal for their position
   - pages at average position 8-20 (page 2, close to page 1)
   - pages that lost the most clicks vs the previous 90 days
   - pages Google hasn't indexed, and why (URL inspection on the important ones)
5. **OpenSEO**: top 3 competitors and 10 keywords they rank for that the site doesn't.
   Start from the profile's competitors if any. Say the cost first and stay within free
   credits unless the user says yes.
6. **Channels and entity**, from the profile's channels list:
   - Does the site link to each channel, and does Organization/Person schema list them
     in `sameAs`?
   - Are the brand name and one-line description consistent across site and channels?
   - YouTube: do channel and video descriptions link back to the site? Is there a video
     for the top target keywords? (Read public pages only, and say so if a page can't be read.)
   - Use `/geo brands <url>` (geo-brand-mentions) for brand presence on the sources AI
     cites (YouTube, Reddit, Wikipedia, LinkedIn).

## Merge

Combine everything into one list and drop duplicates: when two tools report the same
issue, keep one item and cite both as proof. Rank by **traffic impact first, effort
second**. Real Search Console numbers outrank crawler guesses, because they're what Google
actually sees.

Each item:
- the problem, in one line
- the proof (the number, URL or tool result)
- the exact fix
- effort: quick (under 1 hour), medium, or big

Only real findings from the tools. Nothing guessed.

## SEO-AUDIT.md layout (keep it; the fix workflow reads it)

```markdown
# SEO audit: <domain>
Date: YYYY-MM-DD

## Tools that didn't run
- <tool>: <why>          (or "All five tools ran.")

## Current scores
| Tool | Score |
|------|-------|
| Claude SEO (SEO Health) | NN/100 |
| GEO SEO Claude (GEO Score) | NN/100 |
| GEO Optimizer | NN/100 |
| Search Console (90 days) | clicks N, impressions N, CTR N%, avg pos N |

## Top 10 fixes
1. **<problem>**
   - Proof: ...
   - Fix: ...
   - Effort: quick | medium | big

## Everything else
(same format, ranked)

## Competitor keyword gaps
| Keyword | Competitor ranking | Volume | Difficulty |
```

Finish by telling the user the top 3 fixes in chat and where the file is. Add a row to the
profile's "Audit history" table with today's scores.
