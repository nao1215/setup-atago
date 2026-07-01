#!/usr/bin/env bash
#
# version_test.sh — check that resolve_version normalizes explicit versions.
#
# Only explicit versions are tested here; "latest" needs the GitHub API and is
# covered by the gated integration job in .github/workflows/test.yml.
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=./install.sh
source "${here}/install.sh"

failures=0
check() {
  local input="$1" want_tag="$2" want_num="$3"
  INPUT_VERSION="$input"
  TAG="" NUM_VERSION=""
  resolve_version
  if [ "$TAG" != "$want_tag" ] || [ "$NUM_VERSION" != "$want_num" ]; then
    printf 'FAIL: %-8s -> TAG=%s NUM=%s (want TAG=%s NUM=%s)\n' \
      "$input" "$TAG" "$NUM_VERSION" "$want_tag" "$want_num"
    failures=$((failures + 1))
  else
    printf 'ok:   %-8s -> TAG=%s NUM=%s\n' "$input" "$TAG" "$NUM_VERSION"
  fi
}

check "v0.1.0" "v0.1.0" "0.1.0"
check "0.1.0"  "v0.1.0" "0.1.0"
check " 0.1.0" "v0.1.0" "0.1.0" # surrounding whitespace is trimmed

if [ "$failures" -ne 0 ]; then
  printf '%d test(s) failed\n' "$failures" >&2
  exit 1
fi
printf 'all version-normalization tests passed\n'
