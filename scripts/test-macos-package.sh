#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
test_version="0.1.0-test"
archive_path="$project_dir/build/release/pocketportal-connect-$test_version-macos.zip"
test_root="$(mktemp -d "${TMPDIR:-/tmp}/pocketportal-connect-package.XXXXXX")"

cleanup() {
  rm -rf "$test_root"
}
trap cleanup EXIT

"$project_dir/scripts/build-macos-release.sh" "$test_version" >/dev/null
/usr/bin/unzip -q "$archive_path" -d "$test_root/package"

package_dir="$test_root/package/pocketportal-connect-$test_version-macos"
test_home="$test_root/home"
mkdir -p "$test_home"

HOME="$test_home" \
POCKETPORTAL_CONNECT_INSTALL_ROOT="$test_home/install" \
POCKETPORTAL_CONNECT_BIN_DIR="$test_home/bin" \
  "$package_dir/install.sh" >/dev/null
HOME="$test_home" \
POCKETPORTAL_CONNECT_INSTALL_ROOT="$test_home/install" \
POCKETPORTAL_CONNECT_BIN_DIR="$test_home/bin" \
  "$package_dir/install.sh" >/dev/null

installed_command="$test_home/bin/pocketportal-connect"
[[ -L "$installed_command" ]]
installed_version="$(HOME="$test_home" "$installed_command" version)"
[[ "$installed_version" == "$test_version" ]] || {
  echo "Expected version $test_version, received $installed_version." >&2
  exit 1
}
status_output="$(HOME="$test_home" "$installed_command" status)"
grep -q "disconnected" <<<"$status_output"
help_output="$(HOME="$test_home" "$installed_command" --help)"
grep -q "pocketportal-connect connect" <<<"$help_output"
connect_help_output="$(HOME="$test_home" "$installed_command" connect --help)"
grep -q -- "--server wss://HOST:PORT" <<<"$connect_help_output"
HOME="$test_home" \
PATH="/usr/bin:/bin" \
  "$installed_command" disconnect |
  grep -q "is disconnected"

echo "PocketPortal Connect macOS package smoke test passed."
