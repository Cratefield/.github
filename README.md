# Cratefield &middot; `.github`

The GitHub organisation profile for [Cratefield](https://cratefield.com).

- **[`profile/README.md`](profile/README.md)** — the page shown at
  [github.com/Cratefield](https://github.com/Cratefield). GitHub only renders it
  from this exact path in this exact repo.
- **[`assets/logo.svg`](assets/logo.svg)** — the 3&times;3 mark, the source of
  truth. Its geometry matches `assets/favicon.svg` in
  [Cratefield/website](https://github.com/Cratefield/website).
  `logo.png` is rendered from `tools/avatar.html` at 1024&times;1024 for the
  organisation avatar, which has to be uploaded through the GitHub web UI
  (there is no REST API for organisation avatars).
- **[`assets/org-banner.png`](assets/org-banner.png)** — the banner at the top
  of the profile, rendered at 2x from `tools/org-banner.html`.

Images in the profile README are referenced by absolute `raw.githubusercontent`
URL, because relative paths do not resolve for viewers of the org page.

```bash
./tools/render.sh    # regenerate the banner and the avatar (needs Chrome)
```

## The rule that governs this page

Every capability carries `SHIPPING`, `DESIGNED` or `PLANNED`, and the label
controls the tense of the sentence around it.

- `SHIPPING` — merged, tested, in the public repo. Present tense allowed here only.
- `DESIGNED` — specified in public issues, unbuilt. Conditional tense, linked to the issue.
- `PLANNED` — named, unspecified. Nothing written.

The Cratefield control plane is `PLANNED`. Nothing here may describe it as
running, operating or hosting anything.

Claims on this page are duplicated from
[Cratefield/website](https://github.com/Cratefield/website), which is the single
source of truth and tracks each one in its `COPY.md`. **Update them there
first**, then mirror the change here.

## Organisation settings that are not in this repo

Two things live only in the GitHub web UI and have no API:

- The organisation avatar (`assets/logo.png`), at
  `github.com/organizations/Cratefield/settings/profile`.
- The organisation description, which is capped at 160 characters.
