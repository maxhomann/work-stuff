#!/bin/bash
set -e

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
WORK_DIR="${SCRIPT_PATH}"
GIT_LOG_DIR="${WORK_DIR}/gource-git-logs"
FFMPEG_EXE="/c/ProgramData/chocolatey/lib/ffmpeg/tools/ffmpeg/bin/ffmpeg.exe"

GOURCE_OPTIONS='-1920x1080 --camera-mode overview --multi-sampling --auto-skip-seconds 2 --seconds-per-day 1 --file-idle-time 0 --max-file-lag 1 --key --date-format %Y-%m-%d_%H:%M --title '"${PROJECT_NAME}"' --logo '"${PROJECT_LOGO_FILE}"' --hide mouse,progress,filenames --window-position 1900x900 -o -'
FFMPEG_OPTIONS="-y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b:v 6000K"

PROJECT_NAME="Cascara"
PROJECT_LOGO_FILE="/d/development/almex/almex-favico.png"

function logI() {
    echo ""
    echo "= [INFO] ============"
    echo "$1"
}

function logE() {
    echo ""
    echo "= [ERROR] ==========="
    echo "$1"
}

function checkRequiredCommands() {
    if [[ -z $(command -v "${FFMPEG_EXE}") ]]; then
        logE "Could not find ffmpeg in ${FFMPEG_EXE}. Make sure it is available to run this script."
        exit 1
    fi
    if [[ -z $(command -v gource) ]]; then
        logE "Could not find gource in path. Make sure it is installed to run this script."
        exit 1
    fi
}

# Logs a single git repository
function createGitLog() {
    local _folder="$1"
    local _folderName=$(basename "${_folder}")

    logI "Logging git history of ${_folderName}."
    gource --output-custom-log $GIT_LOG_DIR/"${_folderName}".log "${_folder}"
    sed -i -r "s#(.+)\|#\1|/${_folderName}#" $GIT_LOG_DIR/"${_folderName}".log
}

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

# Scan a folder without traversing the sub folders for git repositories
function createGitLogForFolder() {
    local _folder="$1"

    logI "Scanning ${_folder}"
    for entry in "${_folder}"/*; do
        if [[ -d "$entry/.git" ]]; then
            createGitLog $entry
        fi
    done
    if [[ -d "${_folder}"/.git ]]; then
        createGitLog $1
    fi
}

function removeLogsUntil() {
    local _combinedLogFile="$1"
    local _untilDate="$2"

    local _untilDateInSeconds=$(date -d "${_untilDate}" +%s)
    local _untilLineIndex=-1
    local _counter=0
    while read -r line; do
        local _lineTimestamp=$(echo "$line" | cut -d '|' -f1)
        if [[ "${_lineTimestamp}" > "${_untilDateInSeconds}" ]]; then
            _untilLineIndex=$_counter
            break
        fi
        ((_counter++))
    done < "${_combinedLogFile}"

    if [[ $_untilLineIndex -eq -1 ]]; then
        logE "Could not find dates after ${_untilDate} in ${_combinedLogFile}"
        exit 1
    fi
    sed -i "0,${_untilLineIndex}d" "${_combinedLogFile}"
}

checkRequiredCommands

rm -r "${GIT_LOG_DIR}"
mkdir -p "${GIT_LOG_DIR}"

#createGitLogForFolder "/d/development/almex/cascara/core"
createGitLogForFolder "/d/development/almex/cascara/jpos-server"
#createGitLogForFolder "/d/development/almex/cascara/platform-daemon"
#createGitLogForFolder "/d/development/almex/cascara/documentation"
#createGitLogForFolder "/d/development/almex/deutsche-bahn"
#createGitLogForFolder "/d/development/almex/hhag"

COMBINED_LOG_FILE="${GIT_LOG_DIR}/combined.log"
combineGitLogs "${GIT_LOG_DIR}" "${COMBINED_LOG_FILE}"
removeLogsUntil "${COMBINED_LOG_FILE}" "2022-04-01"

#gource ${GOURCE_OPTIONS} "${COMBINED_LOG_FILE}" | "${FFMPEG_EXE}" ${FFMPEG_OPTIONS} "${WORK_DIR}/${PROJECT_NAME}.webm"