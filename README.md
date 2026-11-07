# open-dso

<!-- ENGMODEL-OWNER-UNIT: FU-FAM-GOVERNANCE -->
<!-- TRLC-LINKS: REQ-FAM-001, REQ-FAM-009 -->

Open firmware for digital storage oscilloscopes, as one family: the same features, the same web
UI and the same look on every instrument it supports, written from our own specifications.

This repository holds no code. It explains how the family is built and points to the repositories
that are.

## The idea in one line

**The core is the product; each scope repository is a board-support package.**

`open-dso-core` holds everything that does not depend on one instrument's hardware: the
acquisition engine and its owner loop, the instrument state, protocol decoders, measurements and
analysis, the display renderer, the web server and web client, the SCPI engine, the update
supervisor, the design system and the test environment. A scope repository implements the
hardware abstraction layer (HAL) for its board — acquisition and readout, front end and
calibration, trigger programming, display and input devices, storage, FPGA images — and holds its
specifications, its profile, its installer and the device model its simulator runs.

A feature written once in the core reaches every scope. A difference between scopes is data (the
scope's profile and capabilities), not a branch in core code.

## Repositories

| Repository | What it is | Stage | Visibility |
|---|---|---|---|
| [open-dso-core](https://github.com/labeth/open-dso-core) | The shared product: engine, HAL, renderer, web, SCPI, analysis, supervisor | used by the SDS1000CML+ and the SDS800X HD | public |
| [open-sds1000cml](https://github.com/labeth/open-sds1000cml) | Siglent SDS1000CML+ (SDS1102CML+ and its same-board variants) | released (v1.2.x); running on the core on a branch | public |
| open-sds800xhd | Siglent SDS800X HD | board layer complete, verified in its simulator; no unit yet | private |
| open-dho1000 | Rigol DHO1000 | specifications | private |

A scope repository stays private until its specifications have passed a provenance review and its
firmware runs on a real unit.

## Read next

- [Architecture](docs/architecture.md): the layers, the HAL, how a scope composes the core.
- [Adding a scope](docs/adding-a-scope.md): from specifications to a running port.
- [Contributing](docs/contributing.md): provenance rules, conventions, how changes cross repositories.
- [Status](docs/status.md): what each scope can do today and what is next.
- Decisions: the family's architecture decisions are recorded, with their reasons, in
  [open-dso-core/model/decisions.yml](https://github.com/labeth/open-dso-core/blob/main/model/decisions.yml).
  That file is the single source; this repository links to it rather than copying it.
- [The family model](#the-family-model) and the documentation generated from it.

## The family model

[`model/`](model) is the family's engineering model, written for
[engineering-model-go](https://github.com/labeth/engineering-model-go) (v0.10.0): the family as a
system of systems. It is a publishable CUE module, `github.com/labeth/open-dso/model@v0`, with
[`model/engmod.yml`](model/engmod.yml) as its manifest.

What it covers:

- **Subsystems.** It composes the published models of the public repositories: `open-dso-core`
  (dependency `core`, subsystem `SUB-FAM-CORE`) and `open-sds1000cml` (dependency `sds1000cml`,
  subsystem `SUB-FAM-SDS1000CML`). Their own models hold their requirements, architecture and
  decisions; this model reads only what they publish.
- **Family requirements** (`REQ-FAM-*` in [`model/requirements.yml`](model/requirements.yml)): one
  product family, one shared core, scope repositories as board-support packages, the same feature
  level on every scope, the same web API, the same look, and no vendor material in any public
  repository, with the publication gate and how a scope joins this model. Each one either links to
  the capabilities the core and the scopes publish ([`model/req-links.yml`](model/req-links.yml):
  `core::CAP-DSO-*`, `sds1000cml::CAP-SDS-*`) or realizes the family capability
  `CAP-FAM-OPEN-FIRMWARE`, and is implemented by the documentation in this repository (its
  `TRLC-LINKS` markers). The requirements are `proposed` and the links `claimed` until the family
  owner reviews them.
- **Planned subsystems.** The private scopes (SDS800X HD, DHO1000) appear as planned units
  (`FU-FAM-SDS800XHD`, `FU-FAM-DHO1000`) without a dependency: a public repository's CI cannot
  fetch a private model.
- **Decisions.** The family's architecture decisions stay in the core's log (below); `model/decisions.yml`
  holds only decisions about this model itself (its life-cycle tier, proposed).

The model declares no life-cycle tier yet, so it is checked with the engine's untiered
severities; it moves to the product tier, like the models it composes, once the owner approves the
family requirements and accepts their links (`DEC-TIER-PRODUCT`).

### Generated documentation

[`docs/generated/`](docs/generated) is produced from the model and committed, so a reader needs no
tools: [`ARCHITECTURE.adoc`](docs/generated/ARCHITECTURE.adoc) (the family architecture, the
composed subsystems and what they publish, the requirement links and the traceability appendix),
[`DECISIONS.adoc`](docs/generated/DECISIONS.adoc), [`TRACE-MATRIX.csv`](docs/generated/TRACE-MATRIX.csv)
(every family and composed requirement with its status) and the authored views as Mermaid and SVG
in [`views/`](docs/generated/views). CI regenerates it and fails when the committed files differ,
so the one way to change it is to regenerate:

```sh
# the engine tools, at the release CI pins
for t in engdoc engtrace engview; do
  go install github.com/labeth/engineering-model-go/cmd/$t@v0.10.0
done
# the composed repositories beside this one (existing checkouts are used as they are;
# missing ones are cloned: open-dso-core at main, open-sds1000cml at core-split)
eval "$(scripts/workspace.sh ..)"
scripts/generate.sh
```

`scripts/workspace.sh` writes `open-dso.work.yml` beside the checkouts, mapping each composed
module to its checkout, and prints the `ENGMOD_WORK` line that points the engine at it. Until the
models are published to a registry they resolve only that way; with the replacements active the
lock is not compared (`composition.lock_check_skipped`, a warning).

### How a scope joins the family model

When a scope repository becomes public (see [adding a scope](docs/adding-a-scope.md)) and its
model is held to the product tier, like the core's and the SDS1000CML+'s:

1. Its `model/` is a publishable CUE module (`model/cue.mod/module.cue`, module
   `github.com/labeth/open-<model>/model@v0`) whose public publication lists only ids it owns,
   including its `CAP-*` capabilities.
2. Here: a dependency in `model/engmod.yml`, a subsystem in `model/architecture.yml` (replacing
   its planned unit), links from the family requirements to its capabilities in
   `model/req-links.yml`, and its checkout in `scripts/workspace.sh`.
3. Regenerate `docs/generated/` and add the scope to the tables above and in
   [status](docs/status.md).

## Licence

Documentation in this repository is MIT licensed, like the code repositories it describes.
