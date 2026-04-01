#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
MANIFEST_FILE="$ROOT_DIR/tooling/contracts_manifest.txt"
LOCK_FILE="$ROOT_DIR/tooling/contracts.lock"
VERSIONS_FILE="$ROOT_DIR/packages/shared/lib/src/contracts/contract_versions.dart"

if [ ! -f "$LOCK_FILE" ]; then
  echo "[contract-check] Missing contracts.lock, run ./tooling/update_contract_lock.sh"
  exit 1
fi

extract_version() {
  local key="$1"
  local line
  line=$(grep "static const String $key" "$VERSIONS_FILE" || true)
  if [ -z "$line" ]; then
    echo ""
    return
  fi
  echo "$line" | sed -E "s/.*'([^']+)'.*/\1/"
}

major_of() {
  echo "$1" | cut -d'.' -f1
}

error_count=0
while IFS='|' read -r name version_key file_path; do
  [ -z "$name" ] && continue

  current_version=$(extract_version "$version_key")
  if [ -z "$current_version" ]; then
    echo "[contract-check] $name: version key '$version_key' not found"
    error_count=$((error_count + 1))
    continue
  fi

  abs_file="$ROOT_DIR/$file_path"
  current_hash=$(shasum -a 256 "$abs_file" | awk '{print $1}')

  lock_line=$(grep "^$name|" "$LOCK_FILE" || true)
  if [ -z "$lock_line" ]; then
    echo "[contract-check] $name: missing from lock, run update script"
    error_count=$((error_count + 1))
    continue
  fi

  IFS='|' read -r _ lock_version lock_hash <<< "$lock_line"

  if [ "$current_hash" != "$lock_hash" ]; then
    if [ "$(major_of "$current_version")" = "$(major_of "$lock_version")" ]; then
      echo "[contract-check] $name changed but major version did not bump ($lock_version -> $current_version)"
      error_count=$((error_count + 1))
    fi
  else
    if [ "$current_version" != "$lock_version" ]; then
      echo "[contract-check] $name version changed without API hash change ($lock_version -> $current_version)"
      error_count=$((error_count + 1))
    fi
  fi
done < "$MANIFEST_FILE"

if [ "$error_count" -gt 0 ]; then
  echo "[contract-check] failed with $error_count issue(s)"
  exit 1
fi

echo "[contract-check] passed"
