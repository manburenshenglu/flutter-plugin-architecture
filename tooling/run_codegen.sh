#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

found=0
if command -v rg >/dev/null 2>&1; then
  list_pubspecs() { rg --files apps packages -g 'pubspec.yaml'; }
else
  list_pubspecs() { find apps packages -name pubspec.yaml -type f; }
fi

while IFS= read -r pubspec; do
  if grep -Eq '^\s*build_runner:' "$pubspec"; then
    dir="$(dirname "$pubspec")"
    echo "==> codegen $dir"
    (cd "$dir" && dart run build_runner build --delete-conflicting-outputs)
    found=1
  fi
done < <(list_pubspecs)

if [ "$found" -eq 0 ]; then
  echo "No package with build_runner found under apps/ or packages/."
fi
