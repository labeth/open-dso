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

## Licence

Documentation in this repository is MIT licensed, like the code repositories it describes.
