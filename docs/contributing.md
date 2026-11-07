# Contributing

<!-- ENGMODEL-OWNER-UNIT: FU-FAM-GOVERNANCE -->
<!-- TRLC-LINKS: REQ-FAM-002, REQ-FAM-003, REQ-FAM-007 -->

## Provenance

The family is written from our own specifications. That rule protects every repository:

- **No vendor material, and nothing derived from it, in any public repository** — no vendor code,
  strings, symbol or accessor names, data taken from vendor files, or anything reconstructed from a
  vendor netlist, bitstream or decompiled code.
- Specifications describe the hardware and its interfaces in our own words. Code is written from
  the specifications.
- The one exception is the public instrument interface a host must see verbatim to stay compatible
  (SCPI command names, waveform formats), kept as reviewed tables.
- A contribution states that it was written from the specifications.

## Where a change goes

- A change to how instruments work in general goes to `open-dso-core`, behind an interface, even if
  only one scope uses it today.
- A change specific to one board goes to that scope's repository, with a reason the core cannot
  hold it.
- A change to the HAL is made in the core together with every active scope that implements it, and
  the core's changelog says how to migrate.

## Conventions

- Go: `gofmt`/`gofumpt`, golangci-lint with the shared configuration at 0 issues, tests at every
  step.
- One device `main` per scope; no hidden modes behind environment variables, flags or build tags
  (build tags may only embed assets).
- Comments and documentation hold durable reasons, not progress notes or dates.
- Behaviour changes are deliberate and tested; moves between repositories change no behaviour.
- Every architectural choice with a reasonable alternative is recorded in
  `open-dso-core/model/decisions.yml`.
