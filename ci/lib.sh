#!/usr/bin/env bash
set -euo pipefail

pushd() {
  builtin pushd "$@" > /dev/null
}

popd() {
  builtin popd > /dev/null
}

pkg_json_version() {
  jq -r .version package.json
}

vscode_version() {
  jq -r .version vendor/modules/code-oss-dev/package.json
}

os() {
  local os
  os=$(uname | tr '[:upper:]' '[:lower:]')
  if [[ $os == "linux" ]]; then
    # Alpine's ldd doesn't have a version flag but if you use an invalid flag
    # (like --version) it outputs the version to stderr and exits with 1.
    local ldd_output
    ldd_output=$(ldd --version 2>&1 || true)
    if echo "$ldd_output" | grep -iq musl; then
      os="alpine"
    fi
  elif [[ $os == "darwin" ]]; then
    os="macos"
  fi
  echo "$os"
}

arch() {
  cpu="$(uname -m)"
  case "$cpu" in
    aarch64)
      echo arm64
      ;;
    x86_64 | amd64)
      echo amd64
      ;;
    *)
      echo "$cpu"
      ;;
  esac
}

# Grabs the most recent ci.yaml github workflow run that was triggered from the
# pull request of the release branch for this version (regardless of whether
# that run succeeded or failed). The release branch name must be in semver
# format with a v prepended.
# This will contain the artifacts we want.
# https://developer.github.com/v3/actions/workflow-runs/#list-workflow-runs
get_artifacts_url() {
  local artifacts_url
  local version_branch="v$VERSION"
  local workflow_runs_url="repos/:owner/:repo/actions/workflows/ci.yaml/runs?event=pull_request&branch=$version_branch"
  artifacts_url=$(gh api "$workflow_runs_url" | jq -r ".workflow_runs[] | select(.head_branch == \"$version_branch\") | .artifacts_url" | head -n 1)
  if [[ -z "$artifacts_url" ]]; then
    echo >&2 "ERROR: artifacts_url came back empty"
    echo >&2 "We looked for a successful run triggered by a pull_request with for code-server version: $VERSION and a branch named $version_branch"
    echo >&2 "URL used for gh API call: $workflow_runs_url"
    exit 1
  fi

  echo "$artifacts_url"
}

# Grabs the artifact's download url.
# https://developer.github.com/v3/actions/artifacts/#list-workflow-run-artifacts
get_artifact_url() {
  local artifact_name="$1"
  gh api "$(get_artifacts_url)" | jq -r ".artifacts[] | select(.name == \"$artifact_name\") | .archive_download_url" | head -n 1
}

# Uses the above two functions to download a artifact into a directory.
download_artifact() {
  local artifact_name="$1"
  local dst="$2"

  local tmp_file
  tmp_file="$(mktemp)"

  gh api "$(get_artifact_url "$artifact_name")" > "$tmp_file"
  unzip -q -o "$tmp_file" -d "$dst"
  rm "$tmp_file"
}

rsync() {
  command rsync -a --del "$@"
}

VERSION="$(pkg_json_version)"
export VERSION
ARCH="$(arch)"
export ARCH
OS=$(os)
export OS

# RELEASE_PATH is the destination directory for the release from the root.
# Defaults to release
RELEASE_PATH="${RELEASE_PATH-release}"

# VS Code bundles some modules into an asar which is an archive format that
# works like tar. It then seems to get unpacked into node_modules.asar.
#
# I don't know why they do this but all the dependencies they bundle already
# exist in node_modules so just symlink it. We have to do this since not only VS
# Code itself but also extensions will look specifically in this directory for
# files (like the ripgrep binary or the oniguruma wasm).
symlink_asar() {
  rm -rf node_modules.asar
  if [ "${WINDIR-}" ]; then
    # mklink takes the link name first.
    mklink /J node_modules.asar node_modules
  else
    # ln takes the link name second.
    ln -s node_modules node_modules.asar
  fi
}
