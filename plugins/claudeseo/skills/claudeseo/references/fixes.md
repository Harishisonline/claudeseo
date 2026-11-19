# Fix: apply SEO-AUDIT.md to the site's code

Run inside the website's code folder, after an audit. Check the profile's "Code" line. If
the site is on a hosted builder (Webflow, Wix, Shopify, WordPress, Squarespace) with no
local code, give exact copy-paste changes per page instead of editing files. No `SEO-AUDIT.md`? Run the audit
workflow first (`references/audit.md`).

## 1. Plan, then one OK

Read `SEO-AUDIT.md` and work top of the list first. Show the full plan: one line per fix
with the files it touches. Wait for one OK, then apply them all. Ask again only for
anything that hits the rules below.

## 2. What to fix

- **Low-CTR pages**: rewrite titles and meta descriptions using the real search queries
  from Search Console. Titles under 60 characters, keep each page's meaning.
- **Page-2 pages (positions 8-20)**: add the missing sections the top results cover, and
  add internal links to them from the site's strongest pages.
- **AI search**: run `uvx --from geo-optimizer-skill geo fix --url <site>` to preview
  robots.txt rules, llms.txt, JSON-LD schema and meta tags. Apply only what fits the site
  (e.g. don't add Product schema to a blog, and don't open robots.txt to bots the user blocked
  on purpose).
- **Technical issues** from the audit: broken links, missing alt text, sitemap,
  canonicals, Core Web Vitals.

## 3. Rules (ask first if a fix needs to break one)

- Never delete pages, change URLs or remove content without asking. URL changes lose
  rankings and backlinks.
- Don't invent facts, reviews or stats for the content. Fabricated claims hurt E-E-A-T and
  can be a legal problem.
- Don't deploy anything. The user deploys.

## 4. Finish

- Short summary of every change (file → what changed).
- Re-run `geo audit --url` and `/seo audit` (against a local preview URL if the changes
  aren't deployed yet, and say which one you used). Show before → after scores.
- Update `SEO-AUDIT.md`: mark fixed items, keep what's left, refresh the scores table.
