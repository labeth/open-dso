# Adding a scope

<!-- ENGMODEL-OWNER-UNIT: FU-FAM-GOVERNANCE -->
<!-- TRLC-LINKS: REQ-FAM-003, REQ-FAM-004, REQ-FAM-008, REQ-FAM-009 -->

A new instrument gets its own repository, `open-<model>`, and starts private. A different processor
makes a different scope, whatever the model name says; a model that is the same board with parts
left off is a variant inside an existing scope repository, described by its profile.

## 1. Specifications

Write implementable specifications (`specs/00`–`12`, the same numbering as every scope; topics from
13 up are shared numbers, scope-only topics start at 20). They describe the hardware and its
interfaces in your own words — no vendor code, strings, symbol names or data beyond the public
instrument interface (see [contributing](contributing.md)).

## 2. A simulator before a unit

Build a device model the scope application can run against (the SDS800X HD's tier-1 simulator runs
the application under qemu against a Go model of its registers and buses). Everything in the next
steps is developed and tested there first.

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

## 6. Going public

When the repository — its whole tree and its history — has passed a provenance review, it can become
public and joins the [status](status.md) table. The review is the gate; a running unit is not. A
scope that has not yet run on a real unit is published as verified in simulation only, and says so
in its README and in the status table until a unit confirms it. Its model then joins the
family model as a subsystem once it is held to the product tier (see
[how a scope joins the family model](../README.md#how-a-scope-joins-the-family-model)).
