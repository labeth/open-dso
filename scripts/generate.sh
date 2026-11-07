#!/usr/bin/env bash
# Regenerates docs/generated/ from the family model.
#
# The model composes the public models of open-dso-core and open-sds1000cml,
# so it needs a workspace file naming their checkouts: ENGMOD_WORK, or one
# found above this repository (scripts/workspace.sh writes one). The engine
# tools are those of engineering-model-go at ENGMODEL_VERSION, found on PATH
# (go install github.com/labeth/engineering-model-go/cmd/<tool>@<version>).
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
out="${1:-$repo/docs/generated}"
mkdir -p "$out"
out="$(cd "$out" && pwd)"

# From model/ with --code-root ..: the documentation files carry the
# requirement markers (TRLC-LINKS) that implement the family requirements.
cd "$repo/model"
engdoc --model engmod.yml --requirements requirements.yml --design views.yml \
  --code-root .. --lock check \
  --out "$out/ARCHITECTURE.adoc" --decisions-out "$out/DECISIONS.adoc"
engtrace --model engmod.yml --requirements requirements.yml --code-root .. \
  --format csv --out "$out/TRACE-MATRIX.csv"
engview --model engmod.yml --out-dir "$out/views"
