# Artwork media rights and delivery policy

R8 adds one first-class media record for each of the 96 European art-history
works. The site stores a 960px local thumbnail only when Wikimedia Commons
metadata exposes an explicitly recognised Public Domain, CC0, CC BY, or CC
BY-SA licence. The seed keeps the Commons file page, original URL, licence
URL, author, bilingual alt text, retrieval timestamp, and SHA-256 checksum.

Two Braque works (`portuguese-braque` and `violin-and-candlestick`) remain
external-link-only. Their provider page is shown as a source link, but the
atlas does not copy or render a provider-hosted image. This is a deliberate
fail-closed path for works where a redistributable image licence was not
verified. Google Arts & Culture may be used as a research lead or as a
provider reference; it is not treated as permission to download or rehost an
image unless a separate reusable licence is explicitly documented.

## Data contract

- `media_kind=image`, `usage_mode=bundled`, `license_status=verified`: the
  asset is self-hosted under `apps/web/public/media/artworks/` and rendered by
  the artwork drawer.
- `media_kind=external_link`, `usage_mode=external_link`,
  `license_status=pending`: the UI renders a provider link and a
  non-redistribution note, never an `<img>` element.
- Every artwork media record has a bilingual published source translation,
  an `artwork_sources` provenance row, HTTPS source/original URLs, attribution,
  and Chinese/English alt text.
- The three existing profiles (Bible, Three Kingdoms, Galactic Force) are not
  reseeded or rewritten by R8.

## Generic visual context contract (Bible pilot, 2026-08-09)

The same rights gate now applies to Bible people, events and locations. A
visual asset is not evidence that a person looked a particular way, that an
event was witnessed at the depicted moment, or that a present-day place
photograph reproduces an ancient scene.

- media_role=character_depiction means an illustrative character depiction,
  not a historical portrait or a canonical likeness.
- media_role=event_scene means an illustrative scene, not eyewitness
  documentation.
- media_role=place_view means a documentary view of the named place; the
  UI must state when it is a modern view rather than an ancient reconstruction.
- depiction_status=illustrative and depiction_status=documentary are semantic
  display labels, not licence claims. The licence fields remain the authority
  for redistribution.
- The Bible pilot bundles only three verified Public Domain images locally.
  Any future candidate whose reusable licence, provenance or checksum is not
  verified stays external-link-only and must not be rendered as a remote image.

## Rebuild and verification

Use a disposable PostgreSQL database when refreshing Commons selections:

```bash
MEDIA_ALLOW_OVERWRITE=1 \
DATABASE_URL=postgresql:///literary_atlas_artwork_media_20260802 \
npx tsx scripts/import_commons_artwork_media.ts

DATABASE_URL=postgresql:///literary_atlas_artwork_media_20260802 \
npm run verify:artwork-media
```

The verifier fails on missing or stale files, checksum mismatches, incomplete
provenance, a non-whitelisted licence, missing bilingual source rows, or any
artwork without exactly one media record. After the seed is generated, run a
clean `npm run db:bootstrap` and the verifier again before baking or publishing
the static profile.

## Source guidance

- [Wikimedia Commons — Choosing a license](https://commons.wikimedia.org/wiki/Commons:Choosing_a_license/en)
- [Wikimedia Commons API](https://commons.wikimedia.org/wiki/Commons:API/MediaWiki)
- [Google Arts & Culture partner FAQ](https://support.google.com/culturalinstitute/partners/answer/6002688?hl=en)
- [Google Terms of Service — third-party content](https://policies.google.com/terms?hl=en-US)

The displayed attribution and links are part of the product contract; do not
replace them with a bare remote image URL. When a provider changes a licence,
withdraws a file, or requests a takedown, remove the local asset, update the
deterministic importer fallback, regenerate `054_european_artwork_media.sql`,
run the verifier, and publish a new static build.
