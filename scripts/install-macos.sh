#!/usr/bin/env bash
set -euo pipefail

package_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_name="pocketportal-connect"
version_file="$package_root/VERSION"
default_install_root="$HOME/.local/share/$package_name"
default_bin_dir="$HOME/.local/bin"
install_root="${POCKETPORTAL_CONNECT_INSTALL_ROOT:-$default_install_root}"
bin_dir="${POCKETPORTAL_CONNECT_BIN_DIR:-$default_bin_dir}"

[[ "$(uname -s)" == "Darwin" ]] || {
  echo "This installer currently supports macOS only." >&2
  exit 1
}
[[ -f "$version_file" ]] || {
  echo "VERSION is missing from the PocketPortal Connect package." >&2
  exit 1
}

version="$(sed -n '1p' "$version_file")"
[[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+([.-][A-Za-z0-9.-]+)?$ ]] || {
  echo "Invalid package version: $version" >&2
  exit 1
}

release_dir="$install_root/releases/$version"
command_path="$bin_dir/$package_name"
release_command="$release_dir/bin/$package_name"

mkdir -p "$install_root/releases" "$bin_dir"
if [[ ! -d "$release_dir" ]]; then
  temporary_release="$install_root/releases/.installing-$version-$$"
  mkdir "$temporary_release"
  cp -R "$package_root/." "$temporary_release/"
  mv "$temporary_release" "$release_dir"
fi

[[ -x "$release_command" ]] || {
  echo "Installed package is missing $release_command." >&2
  exit 1
}
if [[ -e "$command_path" && ! -L "$command_path" ]]; then
  echo "Refusing to replace existing non-symlink: $command_path" >&2
  exit 1
fi

temporary_link="$bin_dir/.$package_name-link-$$"
ln -s "$release_command" "$temporary_link"
mv -f "$temporary_link" "$command_path"

echo "Installed PocketPortal Connect $version"
echo "Command: $command_path"
case ":$PATH:" in
  *":$bin_dir:"*) ;;
  *) echo "Add $bin_dir to PATH before running pocketportal-connect." ;;
esac
