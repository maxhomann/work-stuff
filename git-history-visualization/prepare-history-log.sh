#!/bin/bash
set -e

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
WORK_DIR="${SCRIPT_PATH}"
GIT_LOG_DIR="${WORK_DIR}/gource-git-logs"


function logI() {
    echo "$(date -Iseconds) [INFO] $1"
}

function logE() {
    echo "$(date -Iseconds) [ERROR] $1"
}

function checkRequiredCommands() {
    if [[ -z $(command -v gource) ]]; then
        logE "Could not find gource in path. Make sure it is installed to run this script."
        exit 1
    fi
}

# Logs a single git repository
# ARG1: folder to log as absolute path
function createGitLog() {
    local _folder="$1"
    local _folderName=$(basename "${_folder}")

    logI "Logging git history of ${_folderName}."
    gource --output-custom-log $GIT_LOG_DIR/"${_folderName}".log "${_folder}"
    sed -i -r "s#(.+)\|#\1|/${_folderName}#" $GIT_LOG_DIR/"${_folderName}".log
}

# Creates a log for each git repository within a folder, without sub-folder traversal
# ARG1: folder to scan for repos
function createGitLogForFolder() {
    local _folder="$1"

    logI "Scanning ${_folder}"
    for entry in "${_folder}"/*; do
        if [[ -d "$entry/.git" ]]; then
            createGitLog $entry
        fi
    done
    if [[ -d "${_folder}"/.git ]]; then
        createGitLog "${_folder}"
    fi
}

# Combines all .log files within ARG1 to a file named ARG2
# ARG1: Folder with .log files as absolute path
# ARG2: Combined log file
function combineGitLogs() {
    local _gitLogDir="$1"
    local _combinedLogFile="$2"

    logI "Combining all git log files."
    fileNames=""
    for filename in "${_gitLogDir}"/*.log; do
        fileNames="$fileNames $filename"
    done

    cat $fileNames | sort -n >"${_combinedLogFile}"
}

# Removes all lines of ARG1 until the date ARG2 and outputs the result to ARG3.
# ARG1: The file to filter
# ARG2: An ISO 8601 date up until which lines will be removed
# ARG3: A file for the filtered output
function removeLogsUntil() {
    local _combinedLogFile="$1"
    local _untilDate="$2"
    local _filteredFile="$3"

    local _untilDateInSeconds=$(date -d "${_untilDate}" +%s)
    local _untilLineIndex=-1
    local _counter=0

    logI "Filtering combined log file until ${_untilDate}"
    while read -r line; do
        local _lineTimestamp=$(echo "${line}" | cut -d '|' -f1)
        if [[ "${_lineTimestamp}" > "${_untilDateInSeconds}" ]]; then
            logI "Found the first line that is after ${_untilDate}"
            _untilLineIndex=$_counter
            break
        fi
        if [[ $((_counter % 2500)) = "0" ]]; then
            logI "Processed ${_counter} lines until $(date -I -d @"${_lineTimestamp}") ..."
        fi
        _counter=$((_counter+1))
    done < "${_combinedLogFile}"

    if [[ $_untilLineIndex -eq -1 ]]; then
        logE "Could not find dates after ${_untilDate} in ${_combinedLogFile}"
        exit 1
    fi
    sed "1,${_untilLineIndex}d" "${_combinedLogFile}" > "${_filteredFile}"
}

checkRequiredCommands

rm -r "${GIT_LOG_DIR}" || true
mkdir -p "${GIT_LOG_DIR}"

createGitLogForFolder "/d/development/almex/cascara/core"
createGitLogForFolder "/d/development/almex/cascara/jpos-server"
createGitLogForFolder "/d/development/almex/cascara/platform-daemon"
createGitLogForFolder "/d/development/almex/cascara/documentation"
createGitLogForFolder "/d/development/almex/deutsche-bahn/cascara-addons"
createGitLogForFolder "/d/development/almex/deutsche-bahn/cascara-client"
createGitLogForFolder "/d/development/almex/deutsche-bahn/cascara-server"
createGitLogForFolder "/d/development/almex/deutsche-bahn/systemtests"
createGitLogForFolder "/d/development/almex/deutsche-bahn/platform-daemon-addons"
createGitLogForFolder "/d/development/almex/hhag/cascara-addons"
createGitLogForFolder "/d/development/almex/hhag/platform-daemon-addons"

COMBINED_LOG_FILE="${GIT_LOG_DIR}/combined.log"
FILTERED_LOG_FILE="${GIT_LOG_DIR}/filtered.log"
combineGitLogs "${GIT_LOG_DIR}" "${COMBINED_LOG_FILE}"
removeLogsUntil "${COMBINED_LOG_FILE}" "2022-04-01" "${FILTERED_LOG_FILE}"