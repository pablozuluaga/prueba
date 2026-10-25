---
name: b2b-lead-finder
description: |
  Find, verify, and prioritize qualified B2B leads in a specific city or region — businesses that
  publicly mention target services (e.g. "online class", "webinar", "teleconsultation", "virtual
  meeting") on their website, Google Maps profile, Facebook page, or LinkedIn page — and deliver an
  Excel-ready lead table with contact info, evidence quotes, fit rationale, and High/Medium/Low
  priority. Use whenever the user wants to find leads, prospects, potential customers, or target
  businesses in a location; build a lead/prospect/outreach list; or find "businesses
  in <city> that do/offer/mention X" — even if they never say the words "lead generation". Also use
  when the user names a product and asks who in a region might need it, and when a founder asks to
  find their first customers, early adopters, pilot users, or "who should I pitch in <city>".
---

# B2B Lead Finder

Turn a product + location + evidence keywords into a verified, prioritized lead list. The core
promise of this skill is **evidence-based leads**: every row in the final table exists because a
real public source was visited and quoted, not because a name sounded plausible.

## Inputs to collect before starting

Ask for whatever is missing; propose sensible defaults for the rest:

1. **Product / value proposition** — what is being sold, and which capabilities matter
   (e.g. "secure video meetings, class hosting, recording, webinar hosting").
2. **Location** — city or region, used as a hard filter.
3. **Lead categories** — the business types to target (coaching centers, clinics, consultancies…).
4. **Mention terms** — the phrases a qualifying business would use publicly ("online class",
   "teleconsultation", "webinar"…). Include local-language equivalents — in many markets the
   Facebook page is in the local language even when the website is in English.
5. **Target count** — how many verified leads to aim for.
6. **Extra rules** — exclusions, priority preferences, required fields.

A library of ready-made vertical × city campaign presets (e.g. IELTS centers in Karachi, dental
clinics in Riyadh, SaaS agencies in Berlin) is indexed in
[references/presets-index.md](references/presets-index.md) — check the index FIRST whenever the
request matches a known vertical or market; the index is the authoritative list. For uncovered
markets, copy [references/preset-template.md](references/preset-template.md) and fill it from
the nearest neighbor.

## Founder quick start

Founders usually arrive with a product and a city, not a marketing brief. Don't interrogate them
with six questions — derive the brief for them:

1. From their product description (or their website, if they give a URL), **propose** 3–5 lead
   categories and 8–12 mention terms that would mark a business as needing this product. Show the
   proposed config in one compact block and get a yes/edit before spending anything on search.
2. Default the target to **25–50 verified leads**, not hundreds. Founders do personal outreach;
   40 leads with strong evidence beat 500 unsorted rows they'll never work through.
3. Write `why_good_fit` as the sentence the founder could open their first email with
   ("Saw you run nightly IELTS batches over Zoom…") — specific enough to reuse verbatim.
4. Offer to run **one category first as a probe**. If verification confirms that category is rich
   in High-priority leads, expand; if it comes back thin, the founder just learned something about
   their market for the price of one search round.

## Non-negotiable data rules

These exist because a lead list is only as valuable as its worst row — one invented phone number
or dead business discovered by a salesperson poisons trust in the entire table.

- **Never fabricate.** If a phone, email, WhatsApp, or LinkedIn page cannot be found on a real
  public page, leave the cell blank. A blank cell is useful information; a guessed one is a trap.
- **Public business data only.** Collect contact details a business itself publishes (website
  contact page, Google Maps listing, Facebook About). Do not collect personal private data unless
  the business lists it as its official contact.
- **Evidence or it didn't happen.** Every lead carries the exact quoted sentence where the
  mention term appears and the URL where it was seen.
- **Honest counts.** If the target is 500 and only 137 real verified leads exist, deliver 137 and
  say so. Never pad with unverified rows to hit a number.

## Pipeline

Run four phases. On long runs, checkpoint results to disk after every batch — provider rate
limits and session caps can kill a run mid-flight, and a checkpointed run resumes for free.

### Phase 1 — Scope

Confirm inputs, then create the job folder — `./leads/<vertical>-<city>-<YYYY-MM-DD>/` containing
`config.md`, `state.json`, `leads.csv`, and `rejects.csv` — and tell the user that path in the
first status message. Everything the run produces lives there.

Set expectations with real numbers before spending: plan on roughly 5–10 searches plus 3–6 page
fetches per verified lead; verification will reject 30–60% of raw candidates (normal and
healthy — so discover 2–3× the target count); a 10-lead run takes ~30–60 minutes with plain web
search, less with accelerators. Start with 3–5 queries per category per round, and default to a
3-round cap unless the user raises it.

### Phase 2 — Discover (recall-oriented)

For each category, search broadly for candidate businesses:

- Combine category keywords × location × mention terms into many query variations.
- Search the open web AND platform-scoped queries (`site:facebook.com`, `site:linkedin.com/company`,
  Google Maps queries). Different platforms surface different businesses — a coaching center may
  have no website but a very active Facebook page.
- Use local-language mention terms as first-class queries, not an afterthought.
- For each candidate, open its website/Facebook page and record: name, all contact fields found,
  physical address + neighborhood, the exact mention quote, and the source URL.
- WhatsApp numbers usually hide as `wa.me/<number>` or `api.whatsapp.com` links on Facebook pages
  and website footers — grep fetched pages for those patterns rather than expecting a labeled field.
- Deduplicate across the whole run by normalized name — lowercase, strip punctuation, drop legal
  suffixes (ltd, limited, inc, llc, & co) — and also by website domain: two spellings of one
  academy share a domain long before they share a spelling.

Query recipes that work (vary and combine):

```
"<category keyword>" <city> "<mention term>"
site:facebook.com "<mention term (local language)>" <city>
site:linkedin.com/company <category keyword> <city>
"<mention term>" <city> contact OR admission OR appointment
```

Discovery optimizes for recall — it will surface plausible-but-wrong candidates. That is fine.
Do not polish here; verification is the filter.

### Phase 3 — Verify (adversarial, one pass per lead)

Treat every discovery claim as unproven. For each candidate, independently re-visit sources and
confirm:

1. **Real and active** — the business exists and shows recent activity (recent social posts,
   updated Maps profile, working website). Default thresholds: activity within 6 months =
   active; 6–18 months = accept but mark stale in notes; older than 18 months with no other
   signal = reject as inactive. Note the signal either way.
2. **In-location** — physically inside the target location, with the specific area named.
   Cannot confirm → reject.
3. **Genuine mention** — the quoted online-service claim is actually findable at the recorded
   source (or elsewhere on the business's own pages). Cannot find it → reject.
4. **Contact cross-check** — at least one of phone / website / Facebook confirmed by a second
   independent source (Maps listing vs website footer, directory listing, etc.). Note mismatches.
   Record `confidence` = how many independent sources confirmed the business's identity and
   contacts: 1 = single-source (allowed, but say so), 2 = cross-checked, 3+ = solid. Binary
   verified/rejected hides exactly the information a salesperson uses to decide who to call
   first.
5. **Fill gaps** — add any missing public contact fields discovered during verification.

Rejected candidates are kept in a separate rejects file with the rejection reason — the user may
loosen criteria later, and rejects prove the filter is real.

### Phase 4 — Deliver

Produce `leads.csv` and `rejects.csv` plus a short summary: counts by category and priority,
rejection rate and top rejection reasons, and honest notes on coverage gaps.

CSV craft that prevents real-world breakage:

- Write **UTF-8 with BOM** (`utf-8-sig` in Python). Without the BOM, Excel renders non-Latin
  text (Bangla, Arabic, Thai…) as mojibake — and local-language quotes are half the value.
- Quote every field; keep phone numbers as text so leading `+`/`0` survive Excel.
- One row per organization, columns exactly as specified below.

## Priority rubric

When a preset is loaded, its vertical-specific rubric replaces this generic one — the generic
rubric below is the fallback for preset-less runs.

- **High** — runs frequent/recurring online sessions at meaningful scale (daily classes, a
  consultation booking system, scheduled webinars) with a real client/student base. The product
  would replace or upgrade something they demonstrably do every week.
- **Medium** — mentions online services but appears occasional or small-scale.
- **Low** — a single or passing mention; unclear ongoing need.

Tie `why_good_fit` to a specific observed behavior + a specific product capability
("runs live IELTS batches on Zoom nightly → needs stable class hosting + recording"), never a
generic line ("could benefit from video conferencing").

## Output columns

Use exactly these columns, in this order, unless the user overrides:

`organization_name, category, website, google_maps_link, facebook_page, instagram_page,
linkedin_page, phone, whatsapp, email, physical_address, area, online_service_mentioned,
exact_source_quote, source_url, why_good_fit, priority, confidence, notes`

Presets may add market-specific contact columns after `whatsapp` (e.g. `zalo` for Vietnam,
`line` for Thailand/Japan) — in many markets the dominant channel isn't in the base set, and a
lead list missing the channel businesses actually answer on is much less actionable. Keep the
base column order unchanged.

Write rows with [scripts/lead_csv.py](scripts/lead_csv.py) — `append_leads()` (or the CLI)
enforces column order, UTF-8 BOM, and quote-all in one place, and `dedupe_key()` /
`load_state()` / `save_state()` give every run identical dedupe and checkpoint behavior instead
of re-implementing them from prose.

**Quality bar — one illustrative row** (placeholder digits; shape and specificity are the point):

```yaml
organization_name: Example IELTS Academy
category: IELTS, language, and admission coaching centers
website: https://exampleielts.com.bd
phone: "+8801XXXXXXXXX"          # found on website footer, matched Google Maps listing
area: Dhanmondi
online_service_mentioned: Live online IELTS batches
exact_source_quote: "Join our live online IELTS batch — classes every evening via Zoom."
source_url: https://facebook.com/exampleielts/about
why_good_fit: Runs nightly live IELTS batches on Zoom for ~200 students/month — needs
  reliable class hosting, recording for absentees, and admission-webinar support.
priority: High
confidence: 2          # phone matched on website footer + Google Maps listing
notes: Facebook active (posted 2 days ago); phone verified across website + Maps.
```

Weak versions of `why_good_fit` ("could benefit from video conferencing") mean the verification
pass didn't look hard enough — send it back.

## After delivery — outreach handoff

A lead list is a pipeline stage, not an end product. After delivering, check what outreach
tooling exists in the environment and offer the next step instead of stopping:

- **Email verification** — if an email-verification key or skill is available (MillionVerifier,
  ZeroBounce…), offer to validate the `email` column before anyone sends to it.
- **List scoring / sequence copy / campaign upload** — if cold-outreach skills are installed
  (list scoring, campaign copywriting, Smartlead/Instantly upload), offer the chain:
  score the list → draft sequences → upload. `why_good_fit` is written to serve as each lead's
  personalization opener — say so when handing off.
- **No tooling installed** — tell the user the CSV maps directly onto any CRM or outreach
  platform import (HubSpot, Pipedrive, Smartlead, Instantly), with `email`, `organization_name`,
  and `why_good_fit` as the fields that matter most.

Sort any handoff by `priority` then `confidence` descending — the first leads worked should be
the ones most likely to answer.

## Running at scale

- If a workflow/subagent orchestration tool is available, fan discovery out one agent per
  category and verification out one agent per lead (or batches of up to 5 — bigger batches save
  cost but let one hard-to-verify lead starve the others), in parallel. Pass each discovery
  agent the list of already-found names so rounds don't re-surface duplicates.
- Checkpoint to a `state.json` in the job folder after every batch: `{"round": N,
  "seen_names": [...], "confirmed": [...], "rejected": [...]}` — plus append confirmed rows to
  `leads.csv` as they verify, not only at the end. A rate-limited or interrupted run then
  resumes by reading state and skipping finished work instead of re-spending on it.
- Loop discover → verify rounds until the target is met, candidates run dry (two consecutive
  rounds with nothing new), or a round cap is hit.
- Expect the pool to be finite: niche B2B categories in one city often exhaust at a few hundred
  real businesses. Falling short of an ambitious target is a finding, not a failure.
- Optional accelerators, if installed: the `firecrawl` CLI for search + scraping, an Apify
  scraper skill for Google Maps / LinkedIn at volume, a Serper-based Maps skill for structured
  place data. Use them when present; plain web search + page fetches work when not.

## API keys and credentials

This skill ships with **no API keys**, and none may ever be added to it — it is designed to be
shared publicly, and a key committed to a skill leaks to everyone who installs it.

When an accelerator would help but has no working credentials:

1. Check for existing auth first (e.g. `firecrawl --status`, an env file the tool documents).
2. If missing, ask the user running the skill for **their own** key, telling them where to get it
   and roughly what it costs. Never reuse a key found in an unrelated project or paste one from
   documentation.
3. Save what they provide outside the skill folder — an env file in the user's home directory
   with `chmod 600` — so it persists for them but can never be committed with the skill.
4. If the user has no key, continue with plain web search + page fetches. The pipeline degrades
   in speed, not in integrity.

Never print a key back in conversation, logs, or output files; when confirming a save, show the
variable name only.
