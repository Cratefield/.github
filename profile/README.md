<p align="center">
  <img src="https://raw.githubusercontent.com/Cratefield/.github/main/assets/org-banner.png" alt="Cratefield — a modular backend in Rust. Fits almost every app." width="100%">
</p>

<p align="center">
  <a href="https://cratefield.com"><img src="https://img.shields.io/badge/CRATEFIELD.COM-LIVE-4C6FFF?style=for-the-badge&labelColor=0A0A0B" alt="cratefield.com"></a>
  <a href="https://github.com/Factory-Zero/harness"><img src="https://img.shields.io/badge/HARNESS-SHIPPING-EDEBE6?style=for-the-badge&labelColor=0A0A0B" alt="Harness: shipping"></a>
  <img src="https://img.shields.io/badge/CONTROL%20PLANE-PLANNED-8A8A8E?style=for-the-badge&labelColor=0A0A0B" alt="Control plane: planned">
</p>

<p align="center">
  <sub>
    <a href="https://cratefield.com">Site</a> &nbsp;·&nbsp;
    <a href="https://cratefield.com/platform/">Platform</a> &nbsp;·&nbsp;
    <a href="https://cratefield.com/isolation/">Isolation</a> &nbsp;·&nbsp;
    <a href="https://cratefield.com/architecture/">Architecture</a> &nbsp;·&nbsp;
    <a href="https://cratefield.com/modules/">Modules</a> &nbsp;·&nbsp;
    <a href="https://cratefield.com/vs-supabase/">vs Supabase</a> &nbsp;·&nbsp;
    <a href="https://cratefield.com/llms.txt">llms.txt</a>
  </sub>
</p>

---

## A backend you compile, not a platform you configure.

Pick the modules your product needs. They are Rust crates. They compile into one
stateless Worker with its own database, and that Worker runs in **your**
Cloudflare account, not ours.

Your backend is a `Cargo.toml`. Your infrastructure is yours.

---

## Two things, and which is which

This matters more than anything else on this page, so it is first.

| | What it is | Status |
| :--- | :--- | :--- |
| **Harness** | The open-source Rust core. Ten crates, MIT, in [`Factory-Zero/harness`](https://github.com/Factory-Zero/harness). Readable and runnable today. | `SHIPPING` |
| **Cratefield** | The managed control plane that would build a Harness composition and deploy it into the customer's own Cloudflare account. | `PLANNED` |

The control plane is not built. Not a line of it. Everything on the site and in
this org that describes it is written in the conditional, on purpose.

Three labels are used everywhere, and they govern the tense of the sentence
around them:

- `SHIPPING` — merged, tested, in the public repo.
- `DESIGNED` — specified in public issues, unbuilt. Linked to its issue.
- `PLANNED` — named, unspecified. Nothing written.

---

## The composition

Real, from the repository, unedited.

```rust
Harness::builder()
    .venture(Venture::new("acme", "acme.com")
        .public_url("https://acme.com")
        .cors_origins(["https://acme.com"]))
    .module(EmailSignup::new().double_opt_in(true))
    .module(Waitlist::new().products(["alpha"]))
    .runtime(Cloudflare::new()
        .db("DB")
        .mailer(Resend::from_env())
        .captcha(Turnstile::from_env()))
    .build()?
```

That is the whole backend. If a module needs a port the runtime does not
provide, if two modules claim the same route prefix or table, or if a module was
built against a different contract version, **this does not compile**.
Misconfiguration fails `cargo test`, not production.

---

## The argument, in five points

**1. Modules are crates, composed at compile time.** No runtime plugin loading,
no registry service, no feature flags in a dashboard. The binary contains
exactly the modules you listed.

**2. Your account, your bill, your data.** The control plane would hold a
scoped Cloudflare API token you issue and can revoke in one click. Cloudflare
bills you directly. If you fire us, the Worker, the database and the domain keep
running — there is no migration, because nothing was ever on our side.

**3. Isolation is the database boundary, not a policy language.** Every tenant
gets its **own** database. Never schema-per-tenant, never shared tables, no
`search_path` switching, no Row Level Security. Migration history, secrets and
the audit log live inside that database, so backup, restore, move and
offboarding are one-database operations with no blast radius.

**4. Portability is architectural, not a promise.** Modules never touch a vendor
client, a Cloudflare binding or an environment variable. They receive trait
objects and adapters answer. CI builds the example backend to `wasm32` every
commit: a dependency pulling `tokio`, `mio` or `std::fs` fails the build. MIT,
not BSL, not open-core with the good parts withheld.

**5. Stateless by construction, at the edge.** Rust compiled to WebAssembly on
Cloudflare Workers via `workers-rs` and `axum`. No `static mut`, no thread-local
outliving a request. The conformance kit ships the concurrent-request test that
proves it.

Changing modules is a deploy. Toggling one regenerates `Cargo.toml` and
`harness.rs`, rebuilds Rust to wasm and redeploys — tens of seconds to minutes,
with a build log. There is no instant config flip, and we will not draw one.

---

## The ten ports

A module asks for ports by name. A runtime supplies adapters. Nothing in a
module knows which cloud it is on.

| Port | Adapters today |
| :--- | :--- |
| `Database` | SQLite · Cloudflare D1 · Postgres `DESIGNED` |
| `Mailer` | Resend |
| `Captcha` | Turnstile |
| `RateLimiter` | Cloudflare KV · in-memory |
| `Signer` | HMAC, `kid` rotation |
| `KeyValue` | Cloudflare KV · in-memory |
| `HttpClient` | Workers fetch |
| `Clock` | system · fixed (tests) |
| `IdGen` | ULID |
| `Defer` | `wait_until` · tokio `DESIGNED` |

---

## What this does not do

Stated here rather than buried, because trust is the whole strategy.

- **Cloudflare D1 is SQLite, not Postgres.** No pgvector, no extensions, no
  `LISTEN/NOTIFY`. **10 GB per database, a cap Cloudflare does not raise.**
  Single-threaded, so throughput tracks query duration: roughly 1,000
  queries/sec at 1 ms each, about 10/sec at 100 ms.
- **No realtime, no object storage, no dashboard data browser.**
- **No crate is published to crates.io.** Depend on the git repository.
- **The control plane does not exist.**

The exit is documented: the `Database` port already accepts real Postgres, and
the same modules run as a native binary. Both are `DESIGNED`, not `SHIPPING`.

The full comparison, including where Supabase is the better answer, is at
[cratefield.com/vs-supabase](https://cratefield.com/vs-supabase/).

---

## Roadmap, in public

| Capability | Status | Where |
| :--- | :--- | :--- |
| Harness core, Cloudflare runtime, adapters, two modules, `fz` CLI, conformance kit | `SHIPPING` | [harness](https://github.com/Factory-Zero/harness) |
| Postgres adapter and native runtime | `DESIGNED` | [#18–#21](https://github.com/Factory-Zero/harness/issues/18) |
| Auth: passkeys, Google, Apple, Meta, password, magic links, OAuth 2.1 + PKCE, ES256 JWTs with JWKS | `DESIGNED` | [22 issues](https://github.com/Factory-Zero/harness/issues?q=is%3Aissue+auth) |
| Two-tier secrets, envelope encryption, KMS trait, tamper-evident audit log | `DESIGNED` | [#23](https://github.com/Factory-Zero/harness/issues/23), [#24](https://github.com/Factory-Zero/harness/issues/24) |
| The Cratefield control plane | `PLANNED` | not started |
| Hosted on our account, via Workers for Platforms | `PLANNED` | not started |

The roadmap is the issue tracker. There is no private version of it.

---

## Repositories

| Repo | What it is |
| :--- | :--- |
| [**website**](https://github.com/Cratefield/website) | [cratefield.com](https://cratefield.com). Static HTML, no build step, no dependencies |
| **.github** | This page and the mark |
| [**Factory-Zero/harness**](https://github.com/Factory-Zero/harness) | The open-source Rust core. Lives in the Factory Zero org, MIT |

---

## Early access

An email address and, optionally, what you run today. We reply once, when there
is something that can deploy into your account. Nothing else gets sent, and the
address is not shared.

You do not need to sign up to read anything. The source is public.

<p align="center">
  <br>
  <a href="https://cratefield.com/platform/#early-access"><b>cratefield.com/platform</b></a>
  &nbsp;·&nbsp;
  <a href="mailto:hello@cratefield.com">hello@cratefield.com</a>
</p>

<p align="center">
  <sub>MIT license · No tracking cookies · Built by <a href="https://factory0.ventures">Factory Zero</a></sub>
</p>
