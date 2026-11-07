# Status

## SDS1000CML+ (`open-sds1000cml`)

Released firmware for the Siglent SDS1102CML+: acquisition up to the hardware's rates with its own
FPGA images, 52 protocol decoders with hardware protocol triggers, eye and jitter analysis, mask
testing, Bode plots, spectrum and spectrogram, sound analysis, super-resolution stacking, an LCD
user interface, a web UI and phone remote, SCPI over VXI-11, A/B over-the-air updates and a
diagnostics stick. Its move onto `open-dso-core` runs on the `core-split` branch and is verified on
a bench unit against the release's regression checklist.

## SDS800X HD (`open-sds800xhd`, private)

The board layer implements the whole HAL and passes its simulator parity harness: trigger
programming for every trigger type, readout (windows, zoom, compression, segments, roll, peak
detect), the front end and its calibration including self-calibration, display and input, storage,
the frequency counter, census, installer and A/B slots. It runs the core's engine loop, instrument
state and SCPI engine. No unit has been on a bench yet; the arrival plan stages first contact.

## DHO1000 (`open-dho1000`, private)

Specifications.

## Next

- The rest of the product on the core for every scope: the shared web scope, the UI model, and one
  composition entry point, so a scope's `main` is its board plus one call.
- Parity runs: the SDS1000CML+ on its bench and the SDS800X HD in its simulator, against the same
  regression checklist.
