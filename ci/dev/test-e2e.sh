#!/usr/bin/env bash
set -euo pipefail

help() {
  echo >&2 "  You can build with 'yarn watch' or you can build a release"
  echo >&2 "  For example: 'yarn build && yarn build:vscode && KEEP_MODULES=1 yarn release'"
  echo >&2 "  Then 'CODE_SERVER_TEST_ENTRY=./release yarn test:e2e'"
  echo >&2 "  You can manually run that release with 'node ./release'"
}

main() {
  cd "$(dirname "$0")/../.."

  source ./ci/lib.sh

  local dir="$PWD"
  if [[ ! ${CODE_SERVER_TEST_ENTRY-} ]]; then
    echo "Set CODE_SERVER_TEST_ENTRY to test another build of code-server"
  else
    pushd "$CODE_SERVER_TEST_ENTRY"
    dir="$PWD"
    popd
  fi

  echo "Testing build in '$dir'"

  # Simple sanity checks to see that we've built. There could still be things
  # wrong (native modules version issues, incomplete build, etc).
  if [[ ! -d $dir/out ]]; then
    echo >&2 "No code-server build detected"
    help
    exit 1
  fi

  if [[ ! -d $dir/vendor/modules/code-oss-dev/out ]]; then
    echo >&2 "No VS Code build detected"
    help
    exit 1
  fi

  cd test
  yarn playwright test "$@"
}

main "$@"
