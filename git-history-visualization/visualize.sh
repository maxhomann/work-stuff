#!/bin/bash
set -e

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
WORK_DIR="${SCRIPT_PATH}"
GIT_LOG_DIR="${WORK_DIR}/gource-git-logs"
FFMPEG_EXE="/c/ProgramData/chocolatey/lib/ffmpeg/tools/ffmpeg/bin/ffmpeg.exe"

PROJECT_NAME="Almex"
LOGO_FILE="logo.png"

GOURCE_OPTIONS='-1920x1080 --camera-mode overview --background 515154 --multi-sampling --auto-skip-seconds 2 --seconds-per-day 1 --file-idle-time 0 --max-file-lag 0.8 --key --date-format %Y-%m-%d_%H:%M --title '${PROJECT_NAME}' --logo '"${LOGO_FILE}"' --hide mouse,progress,filenames --window-position 1900x900 -o -'
FFMPEG_OPTIONS="-y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b:v 6000K"

function logE() {
    echo "$(date -Iseconds) [ERROR] $1"
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

checkRequiredCommands

FILTERED_LOG_FILE="${GIT_LOG_DIR}/filtered.log"

gource ${GOURCE_OPTIONS} "${FILTERED_LOG_FILE}" | "${FFMPEG_EXE}" ${FFMPEG_OPTIONS} "${WORK_DIR}/${PROJECT_NAME}.webm"