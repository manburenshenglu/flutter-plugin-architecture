#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST_FILE="$ROOT_DIR/tooling/contracts_manifest.txt"
LOCK_FILE="$ROOT_DIR/tooling/contracts.lock"
VERSIONS_FILE="$ROOT_DIR/packages/shared/lib/src/contracts/contract_versions.dart"

extract_version() {
  local key="$1"
  local line
  line=$(grep "static const String $key" "$VERSIONS_FILE" || true)
  echo "$line" | sed -E "s/.*'([^']+)'.*/\1/"
}

: > "$LOCK_FILE"
while IFS='|' read -r name version_key file_path; do
  [ -z "$name" ] && continue
  version=$(extract_version "$version_key")
  hash=$(shasum -a 256 "$ROOT_DIR/$file_path" | awk '{print $1}')
  echo "$name|$version|$hash" >> "$LOCK_FILE"
done < "$MANIFEST_FILE"

echo "Updated $LOCK_FILE"
