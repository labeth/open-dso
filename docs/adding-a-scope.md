# Adding a scope

<!-- ENGMODEL-OWNER-UNIT: FU-FAM-GOVERNANCE -->
<!-- TRLC-LINKS: REQ-FAM-003, REQ-FAM-004, REQ-FAM-008, REQ-FAM-009 -->

A new instrument gets its own repository, `open-<model>`, and starts private. A different processor
makes a different scope, whatever the model name says; a model that is the same board with parts
left off is a variant inside an existing scope repository, described by its profile.

## 1. Specifications

Write implementable specifications (`specs/00`–`12`, the same numbering as every scope; topics from
13 up are shared numbers, scope-only topics start at 20). They describe the hardware and its
interfaces in your own words — no vendor code, files, strings, symbol names, codenames or
descriptions of the vendor firmware's internals. Hardware facts (registers, sequences, timings, pin
maps, key codes) are hardware description, marked UNVERIFIED until measured on a unit; interface
literals the firmware or a host must use stay verbatim (see [contributing](contributing.md)).

## 2. A simulator before a unit

Build a device model the scope application can run against: the scope's own firmware binary runs
under QEMU, with its Linux, against a model of the scope's registers, FPGA, DMA, interrupts, front
end and panel (the SDS800X HD's tier-1 simulator works this way). Everything in the next steps is
developed and tested there first: installing and updating, faults, triggers firing, decoding, the
LCD and the web UI.

This is a different thing from the browser demo. The demo runs only the core, in WebAssembly,
against a simulated board built from the scope's profile; it shows how the product looks and
behaves, not whether the scope's board code works. The full simulator is the end-to-end test.

## 3. The board

Implement `hal.Board` in `app/internal/…`, one interface at a time, against the simulator:
platform and takeover, planner, acquirer, readout, trigger, front end, display, input, storage.
Write `profile.yaml` (channels, code format, rates, display, inputs, budget, the reasons for absent
optional parts). Run the core's conformance suites against the board.

## 4. The product comes for free

The scope's `main` builds the board and runs the core: engine, UI model, renderer, web server and
client, SCPI engine (with the scope's dialect table), supervisor. Anything the core cannot do for
this board is a HAL capability the board reports as absent, with the reason.

## 5. First contact with a unit

Staged, from safe to risky: a read-only census of the unit, then the application reading only while
the vendor firmware owns the front end, then front-end and trigger writes, then display. A recovery
procedure is proven on the unit before anything is installed.

## 6. First release

Tag a first release when the firmware runs on a unit, installs and recovers safely, and passes the
family's regression checklist. Until then the scope is marked verified in simulation only, in its
README and in the [status](status.md) table.

## Making a repository public

A scope repository can be made public at any stage, from specifications only to released firmware,
once its whole tree and history have passed a provenance review. It then joins the status table, and
its model joins the family model as a subsystem once it is held to the product tier (see
[how a scope joins the family model](../README.md#how-a-scope-joins-the-family-model)).
