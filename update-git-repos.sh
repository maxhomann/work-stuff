#!/bin/bash

ROOT_FOLDER="/d/development"

function logI() {
	echo "$(date -Iseconds) [INFO $(basename $0)] $1"
}

function failOnNonZeroExit() {
  if [[ $1 -ne 0 ]]; then
    logI "Command failed for $_rootDir"
    sleep 15
    #exit 1
  fi
}

function updateRepo() {
  local _repo="${ROOT_FOLDER}/$1"
  local _rootDir=$PWD

  cd "${_repo}" || return
  echo "##### ${_repo} #####"

  local _cleanIndex=1
  if [[ $(git status -s | wc -m) -ne 0 ]]; then
    logI "Repo has local changes, the index is not clean."
    _cleanIndex=0
  fi

  local _gitBranch
  _gitBranch="$(git branch --show-current)"
  
  local _isOnMainBranch=0
  if [[ "${_gitBranch}" =~ ^(develop|master|trunk|main|development|main/.*)$ ]]; then
    #logI "Repo is on a known main branch."
    _isOnMainBranch=1
  fi

  if [ ${_isOnMainBranch} -eq 1 ] && [ ${_cleanIndex} -eq 1 ]; then
    logI "Pulling ${_repo}"
    git pull --tags --all --prune
    failOnNonZeroExit $?
  else
    logI "Fetching ${_repo}"
    git fetch --prune --tags --all
    failOnNonZeroExit $?
  fi
  echo ""
  echo ""

  cd "${_rootDir}" || exit
}


function updateEon() {

  updateRepo eon/ipenplatform/products/grid-structure/grid-structure-docs
  updateRepo eon/ipenplatform/products/grid-structure/infrastructure
  updateRepo eon/ipenplatform/products/grid-structure/api
  updateRepo eon/ipenplatform/products/grid-structure/api-specs
  updateRepo eon/ipenplatform/products/grid-structure/api-infrastructure
  updateRepo eon/ipenplatform/products/grid-structure/data-loader
  updateRepo eon/ipenplatform/products/grid-structure/experimental
  updateRepo eon/ipenplatform/products/grid-structure/model-schema
  updateRepo eon/ipenplatform/products/grid-structure/neo4j-data-loader
  updateRepo eon/ipenplatform/products/grid-structure/neo4j-extensions
  updateRepo eon/ipenplatform/products/grid-structure/neo4j-spatial-plugin
  updateRepo eon/ipenplatform/products/grid-structure/flux-grid-structure
  
}

function updateEon2() {
	updateRepo eon/energieplattformtwistringen/other
	updateRepo eon/energieplattformtwistringen/scheduling-module
	updateRepo eon/energieplattformtwistringen/documentation
}

function updateOthers() {
	updateRepo eon/ipenplatform/ci
	updateRepo eon/ipenplatform/ipen-docs
	updateRepo eon/ipenplatform/products/api-management/published-apis/api-specs
}

updateEon
updateEon2
updateOthers

logI "Done!"

# TODO implement directory recursion
#sleep 60
