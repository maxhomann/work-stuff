#!/usr/bin/env bash

SCRIPT_DIR=$PWD

function logInfo() {
  echo ""
  echo "=== [INFO]"
  echo "$1"
}

function logErr() {
  echo ""
  echo "ERROR: $1"
}

function setVariable() {
  local varname=$1
  shift
  if [ -z "${!varname}" ]; then
    eval "$varname=\"$1\""
  else
    logErr "Variable $varname already set!"
    printUsage
  fi
}

function printUsage() {
  echo "$0 to restore a git bundle file as a local repository."
  echo ""
  echo "Usage: $0 <bundle_file_name> <target_folder>"
  echo "  where"
  echo "  <bundle_file_name> must be a file from the \"bundles\" folder"
  echo "  <target_folder> must be a relative or absolute path to a new directory"
  exit 2
}

[ -z "$1" ] || [ -z "$2" ] && printUsage
setVariable _bundleFile "$1"
setVariable _restoreDir "$2"

logInfo "Initializing restore repo ..."
mkdir -p "${_restoreDir}"
git init "${_restoreDir}"

logInfo "Restoring ..."
cd "${_restoreDir}" || exit
_bundlePath="$SCRIPT_DIR"/"${_bundleFile}"
if [ ! -f "${_bundlePath}" ]; then
  logErr "Could not find bundle file: ${_bundlePath}"
fi
git fetch --update-head-ok "${_bundlePath}" '*:*'