#!/usr/bin/env bash
#
# version_test.sh — check that version resolution normalizes explicit versions
# and parses the GitHub API response for `latest`.
#
set -euo pipefail

here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source-path=SCRIPTDIR
# shellcheck source=install.sh
source "${here}/install.sh"

failures=0

check_tag_name() {
  local body="$1" want="$2" got
  got="$(extract_tag_name "$body")"
  if [ "$got" != "$want" ]; then
    printf 'FAIL: extract_tag_name(...) -> %s (want %s)\n' "$got" "$want"
    failures=$((failures + 1))
  else
    printf 'ok:   extract_tag_name(...) -> %s\n' "$got"
  fi
}

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

check_latest() {
  INPUT_VERSION="latest"
  TAG="" NUM_VERSION=""
  gh_curl() {
    printf '%s\n' '{"url":"https://api.github.com/repos/nao1215/atago/releases/1","tag_name":"v0.1.1","name":"v0.1.1"}'
  }
  resolve_version
  if [ "$TAG" != "v0.1.1" ] || [ "$NUM_VERSION" != "0.1.1" ]; then
    printf 'FAIL: latest -> TAG=%s NUM=%s (want TAG=v0.1.1 NUM=0.1.1)\n' "$TAG" "$NUM_VERSION"
    failures=$((failures + 1))
  else
    printf 'ok:   latest   -> TAG=%s NUM=%s\n' "$TAG" "$NUM_VERSION"
  fi
}

check_tag_name '{"tag_name":"v0.1.1"}' "v0.1.1"
check_tag_name '{"name":"demo","tag_name":"v2.0.0","draft":false}' "v2.0.0"
check "v0.1.0" "v0.1.0" "0.1.0"
check "0.1.0"  "v0.1.0" "0.1.0"
check " 0.1.0" "v0.1.0" "0.1.0" # surrounding whitespace is trimmed
check_latest

if [ "$failures" -ne 0 ]; then
  printf '%d test(s) failed\n' "$failures" >&2
  exit 1
fi
printf 'all version-normalization tests passed\n'
