# Architecture

## Layers

| Layer | Lives in | Holds |
|---|---|---|
| Product | `open-dso-core` | engine (owner loop, publish gate, pacing, history), instrument state, UI model, renderer, web server and client, SCPI engine, decode, analysis, measurement, sound, super-resolution, design system, supervisor, diagnostics framework, test environment |
| HAL | `open-dso-core/hal` | the interfaces a board implements, and the frame type (`sample`) and profile schema (`profile`) they exchange |
| Board | `open-<model>` | the HAL implementation, specifications, `profile.yaml`, FPGA images, SCPI dialect table, installer or stick, simulator device model |

Code stays per scope only when a written reason says it must. When in doubt it goes to the core
behind an interface.

## The HAL

A board implements `hal.Board`:

| Interface | What the board does |
|---|---|
| `Platform` | bring-up and takeover from the vendor firmware, the owner's `Service` hook, reboot policy |
| `Planner` | turns a request (time/div, depth, mode) into a portable plan |
| `Acquirer` | configure, arm, wait, stop — settings are staged and committed together at `Arm` |
| `Readout` | delivers windows of a stored record as frames that state their content kind and code format |
| `Trigger` | programs typed trigger stages, or refuses with the reason; reports its capabilities per FPGA image |
| `FrontEnd` | channel settings in volts, the V/div ladder, calibration, self-calibration |
| `Display`, `Input`, `Storage` | framebuffer or hardware waveform renderer, keys/knobs/touch/LEDs, settings storage |
| optional | `Streamer`, `Images`, `Stacker`, `Segments`, `Counter`, `LogicProbe`, `Generator` |

The rules that make one engine fit very different hardware:

- **Frames describe themselves.** A frame says whether it holds raw full-rate samples, peak pairs
  or resampled points, in which code format (8-bit, 12-bit left-aligned, …), with its own volts
  scale. A feature that needs raw data is refused on a scope that cannot deliver it, never fed the
  wrong kind.
- **Volts and seconds at the boundary.** Controllers (UI, SCPI, web, settings) speak physical
  units; DAC codes, detent indexes and screen pixels exist only inside a board.
- **Refuse with the reason.** A board never substitutes a different setting for the one asked; it
  refuses and says why, and the reason reaches the user on the screen, the web page and SCPI.
- **The core owns the loop.** The engine's owner loop commits settings in HAL order, arms, waits,
  reads and publishes; a board supplies the steps.
- **The FPGA decides the trigger.** Software only refines the trigger position (one exception: on a
  gap-free decoded stream, software may be the trigger).

## How a scope composes the core

Each scope repository has two Go modules:

- `app/` — the scope application: one device `main` that builds its board and hands it to the
  core. It depends only on the Go standard library and `open-dso-core`.
- `ota/` — the update agent: the core's supervisor module with the board's takeover, watchdog or
  health check, and its stick or installer.

Both pin the same core version. During development a sibling checkout of `open-dso-core` is used
through a `replace` directive; CI checks the core out next to the repository.

## The web API

One web server (`open-dso-core/webserver`) serves one web client (`open-dso-core/webclient`) on every
scope. The page reads the scope's capabilities from `/api/caps` — channels, code format, ladders,
trigger types, available features — and adapts. Frames travel in a self-describing binary format
(`DSF2`) carrying any number of channels and any code format.

## Engineering model

Every repository has an engineering model (requirements, architecture, decisions) validated in CI
with [engineering-model-go](https://github.com/labeth/engineering-model-go). Scope models compose the
core's model: a scope's requirements trace to its own code, and to the core's capabilities where the
core implements them.
