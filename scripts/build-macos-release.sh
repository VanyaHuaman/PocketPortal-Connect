#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
package_name="pocketportal-connect"
version="${1:-}"
release_root="$project_dir/build/release"
package_dir="$release_root/$package_name-$version-macos"
archive_path="$release_root/$package_name-$version-macos.zip"
engine_distribution="$project_dir/build/install/pocketportal-connect-engine"

[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]] || {
  echo "Usage: $0 VERSION" >&2
  exit 2
}

"$project_dir/gradlew" -p "$project_dir" \
  -PpocketPortalConnectVersion="$version" clean test installDist

rm -rf "$package_dir"
mkdir -p "$package_dir/bin" "$package_dir/lib" "$package_dir/libexec"
cp -R "$engine_distribution" "$package_dir/libexec/pocketportal-connect-engine"
cp "$project_dir/scripts/pocketportal-connect" "$package_dir/bin/pocketportal-connect"
cp "$project_dir/scripts/connect-macos.sh" "$package_dir/lib/connect-macos.sh"
cp "$project_dir/scripts/connect-device-picker.js" \
  "$package_dir/lib/connect-device-picker.js"
cp "$project_dir/scripts/release-metadata.js" \
  "$package_dir/lib/release-metadata.js"
cp "$project_dir/scripts/install-macos.sh" "$package_dir/install.sh"
printf '%s\n' "$version" >"$package_dir/VERSION"
chmod +x \
  "$package_dir/bin/pocketportal-connect" \
  "$package_dir/lib/connect-macos.sh" \
  "$package_dir/install.sh"

rm -f "$archive_path"
(
  cd "$release_root"
  /usr/bin/zip -qry "$(basename "$archive_path")" "$(basename "$package_dir")"
)
echo "$archive_path"
