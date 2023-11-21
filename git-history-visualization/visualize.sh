#!/bin/bash
set -e

SCRIPT_PATH=$(dirname "$(readlink -f "$0")")
WORK_DIR="${SCRIPT_PATH}"
GIT_LOG_DIR="${WORK_DIR}/gource-git-logs"
FFMPEG_EXE="/c/ProgramData/chocolatey/lib/ffmpeg/tools/ffmpeg/bin/ffmpeg.exe"

PROJECT_NAME="E.ON Model Schema"
LOGO_FILE="gs-logo.svg"

GOURCE_OPTIONS='-1920x1080 --camera-mode overview --background 515154 --multi-sampling --bloom-multiplier 0.6 --auto-skip-seconds 2 --seconds-per-day 2 --file-idle-time 0 --max-file-lag 0.8 --key --date-format %Y-%m-%d_%H:%M --logo '"${LOGO_FILE}"' --hide mouse,progress,filenames --window-position 1900x900 -o -'
GOURCE_TITLE=(--title "${PROJECT_NAME}")
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

LOG_FILE="${GIT_LOG_DIR}/model-schema.log"

gource "${GOURCE_TITLE[@]}" ${GOURCE_OPTIONS} "${LOG_FILE}" | "${FFMPEG_EXE}" ${FFMPEG_OPTIONS} "${WORK_DIR}/${PROJECT_NAME}.webm"