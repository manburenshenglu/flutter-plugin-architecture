#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APPS_DIR="$ROOT_DIR/apps"
PACKAGES_DIR="$ROOT_DIR/packages"

repair_dir_if_flutter_package() {
  local package_path="$1"
  local package_name
  local pubspec
  package_name="$(basename "$package_path")"
  pubspec="$package_path/pubspec.yaml"

  if [ ! -f "$pubspec" ]; then
    return 0
  fi

  if grep -q "^name:" "$pubspec"; then
    echo "== repairing IDE metadata for $package_name"
    (cd "$package_path" && flutter create . >/dev/null)
  fi
}

if [ -d "$APPS_DIR" ]; then
  for app_path in "$APPS_DIR"/*; do
    [ -d "$app_path" ] || continue
    repair_dir_if_flutter_package "$app_path"
  done
else
  echo "apps directory not found: $APPS_DIR"
fi

if [ -d "$PACKAGES_DIR" ]; then
  for package_path in "$PACKAGES_DIR"/*; do
    [ -d "$package_path" ] || continue
    if [ "$(basename "$package_path")" = "modules" ]; then
      continue
    fi
    repair_dir_if_flutter_package "$package_path"
  done

  if [ -d "$PACKAGES_DIR/modules" ]; then
    for module_path in "$PACKAGES_DIR/modules"/*; do
      [ -d "$module_path" ] || continue
      repair_dir_if_flutter_package "$module_path"
    done
  fi
else
  echo "packages directory not found: $PACKAGES_DIR"
fi

echo "IDE metadata repair completed."
