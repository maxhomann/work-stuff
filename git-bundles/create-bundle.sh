#!/usr/bin/env bash

BUNDLES_FOLDER=bundles

function logInfo() {
  echo ""
  echo "=== [INFO]"
  echo "$1"
}

function logError() {
  echo ""
  echo "ERROR: $1"
}

function setVariable() {
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$1\""
  else
    logError "Variable $varname already set!"
    printUsage
  fi
}

function printUsage() {
  echo "$0 to create git bundle files that create a full archive of a repository."
  echo ""
  echo "Usage: $0 <clone_url> <repo_name>"
  echo "  where"
  echo "  <clone_url> is the repository url to archive"
  echo "  <repo_name> is the name of the cloned repository"
  exit 2
}

[ -z "$1" ] || [ -z "$2" ] && printUsage

setVariable _remoteRepoUrl "$1"
setVariable _repoName "$2"

logInfo "Cloning repository ..."
git clone ${_remoteRepoUrl} ${_repoName} || exit 1
cd "${_repoName}" || exit 1
logInfo "Creating bundle ..."
git bundle create --all-progress ../${BUNDLES_FOLDER}/"${_repoName}".bundle --all
cd ..

logInfo "Verifying bundle ..."
git bundle verify ${BUNDLES_FOLDER}/"${_repoName}".bundle

logInfo "Deleting cloned repository ..."
rm -rf "${_repoName}"

