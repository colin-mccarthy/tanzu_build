#!/usr/bin/env bash
set -euo pipefail

main() {
  cd "$(dirname "$0")/../.."

  local prettierExts
  prettierExts=(
    "*.js"
    "*.ts"
    "*.tsx"
    "*.html"
    "*.json"
    "*.css"
    "*.md"
    "*.toml"
    "*.yaml"
    "*.yml"
    "*.sh"
  )
  prettier --write --loglevel=warn $(
    git ls-files "${prettierExts[@]}" | grep -v "lib/vscode" | grep -v "vendor/modules/code-oss-dev" | grep -v 'helm-chart'
  )

  doctoc --title '# FAQ' docs/FAQ.md > /dev/null
  doctoc --title '# Setup Guide' docs/guide.md > /dev/null
  doctoc --title '# Install' docs/install.md > /dev/null
  doctoc --title '# npm Install Requirements' docs/npm.md > /dev/null
  doctoc --title '# Contributing' docs/CONTRIBUTING.md > /dev/null
  doctoc --title '# Maintaining' docs/MAINTAINING.md > /dev/null
  doctoc --title '# Contributor Covenant Code of Conduct' docs/CODE_OF_CONDUCT.md > /dev/null
  doctoc --title '# iPad' docs/ipad.md > /dev/null
  doctoc --title '# Termux' docs/termux.md > /dev/null

  # TODO: replace with a method that generates fewer false positives.
  if [[ ${CI-} && $(git ls-files --other --modified --exclude-standard) ]]; then
    echo "Files need generation or are formatted incorrectly:"
    git -c color.ui=always status | grep --color=no '\[31m'
    echo "Please run the following locally:"
    echo "  yarn fmt"
    exit 1
  fi
}

main "$@"
