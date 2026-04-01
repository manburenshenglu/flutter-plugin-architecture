#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APPS_DIR="$ROOT_DIR/apps"

if [ ! -d "$APPS_DIR" ]; then
  echo "apps directory not found: $APPS_DIR"
  exit 1
fi

for app_path in "$APPS_DIR"/*; do
  [ -d "$app_path" ] || continue
  app_name="$(basename "$app_path")"
  pubspec="$app_path/pubspec.yaml"

  if [ ! -f "$pubspec" ]; then
    continue
  fi

  if grep -q "^name:" "$pubspec"; then
    echo "== repairing IDE metadata for $app_name"
    (cd "$app_path" && flutter create . >/dev/null)
  fi
done

echo "IDE metadata repair completed."
