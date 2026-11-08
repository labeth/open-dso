#!/usr/bin/env bash
# Prepares the workspace the family model composes in: a checkout of each
# public repository whose model it composes, beside this repository (or in
# the directory given), and a workspace file naming them.
#
#   scripts/workspace.sh [DIR]      DIR defaults to this repository's parent
#
# A checkout already in DIR (a clone or a git worktree) is used as it is (no
# fetch, no branch switch), so local work sees the working trees of the
# sibling repositories. A missing one is cloned at DSO_CORE_REF (default
# main), SDS1000CML_REF (default main, where the SDS1000CML+ model
# composes the core) or SDS800XHD_REF (default main).
#
# Every composed repository must be public: the clone is anonymous, and a
# repository that is private or missing fails the script with its name.
#
# The workspace file is DIR/open-dso.work.yml; an existing engmod.work.yml in
# DIR is left alone. Point the engine at it with the printed line:
#   export ENGMOD_WORK=DIR/open-dso.work.yml
set -euo pipefail

repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
dir="${1:-$repo/..}"
mkdir -p "$dir"
dir="$(cd "$dir" && pwd)"

checkout() { # name ref
  if [[ -e "$dir/$1/.git" ]]; then
    echo "workspace: using $dir/$1 ($(git -C "$dir/$1" rev-parse --abbrev-ref HEAD) $(git -C "$dir/$1" rev-parse --short HEAD))" >&2
  else
    if ! GIT_TERMINAL_PROMPT=0 git clone --quiet --depth 1 --branch "$2" "https://github.com/labeth/$1.git" "$dir/$1"; then
      echo "workspace: cannot clone labeth/$1 at $2 anonymously: the repository is private, missing or has no such branch; the family model composes only public repositories" >&2
      exit 1
    fi
    echo "workspace: cloned $1 at $2 ($(git -C "$dir/$1" rev-parse --short HEAD))" >&2
  fi
}
checkout open-dso-core "${DSO_CORE_REF:-main}"
checkout open-sds1000cml "${SDS1000CML_REF:-main}"
checkout open-sds800xhd "${SDS800XHD_REF:-main}"

cat > "$dir/open-dso.work.yml" <<'WORK'
schemaVersion: 2
replacements:
- module: github.com/labeth/open-dso-core/model@v0
  path: ./open-dso-core/model
- module: github.com/labeth/open-sds1000cml/model@v0
  path: ./open-sds1000cml/model
- module: github.com/labeth/open-sds800xhd/model@v0
  path: ./open-sds800xhd/model
WORK
echo "export ENGMOD_WORK=$dir/open-dso.work.yml"
