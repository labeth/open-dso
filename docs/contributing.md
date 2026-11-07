# Contributing

<!-- ENGMODEL-OWNER-UNIT: FU-FAM-GOVERNANCE -->
<!-- TRLC-LINKS: REQ-FAM-002, REQ-FAM-003, REQ-FAM-007 -->

## Provenance

The family is written from our own specifications. That rule protects every repository:

- **Never in a public repository:** vendor code; vendor files, verbatim or transcribed (scripts,
  configuration, tables, headers); vendor strings; vendor symbol, function, class and accessor names;
  internal codenames; and descriptions of how the vendor firmware behaves internally (its loops,
  polls, threads, caches, bugs and order of operations).
- **Hardware facts may be published as hardware description**, in our own words: register maps,
  initialisation values and sequences, timings, pin and ball maps, I/O standards, key codes — also
  when they were learned from the vendor firmware or bitstream. Each is stated as what the hardware
  needs, without attribution, and marked **UNVERIFIED** until it is measured on a unit.
- **Interoperation literals stay verbatim**, kept to what the firmware or a host must use: device
  paths, file names the firmware must open or must never write, device-tree compatibles, and the
  public instrument interface (SCPI command names from the public programming guides, waveform
  formats and their public field names), kept as reviewed tables.
- Specifications describe the hardware and its interfaces in our own words. Code is written from
  the specifications.
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
  `open-dso-core/model/decisions.yml`; this repository's `model/decisions.yml` holds only
  decisions about the family model itself.
