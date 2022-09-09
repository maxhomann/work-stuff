#!/bin/bash
set -e
set -x


PROJECT_NAME="Cascara"
PROJECT_DIR="/c/development/cascara/cascara/core"
GOURCE_WORK_DIR="/c/development/cascara/gource"
LOG_DIR="${GOURCE_WORK_DIR}/logs"
FFMPEG_PATH="/c/ProgramData/chocolatey/lib/ffmpeg/tools/ffmpeg/bin/ffmpeg.exe"
PROJECT_LOGO_PATH="/c/development/cascara/almex-favico.png"

GOURCE_OPTIONS='-1920x1080 --camera-mode overview --multi-sampling --auto-skip-seconds 2 --seconds-per-day 1 --file-idle-time 0 --max-file-lag 1 --key --date-format %Y-%m-%d_%H:%M --title '"${PROJECT_NAME}"' --logo '"${PROJECT_LOGO_PATH}"' --hide mouse,progress,filenames --window-position 1900x900 -o -'
FFMPEG_OPTIONS="-y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libvpx -b:v 6000K"


# Logs a single git repository
function createGitLog() {
	local _targetFolderName=$(basename $1)
	
	gource --output-custom-log $LOG_DIR/"${_targetFolderName}".log $1
	sed -i -r "s#(.+)\|#\1|/"${_targetFolderName}"#" $LOG_DIR/"${_targetFolderName}".log
}

function combineGitLogs() {
	fileNames=""
	for filename in $LOG_DIR/*.log; do
		fileNames="$fileNames $filename"
	done

	cat $fileNames | sort -n > $LOG_DIR/combined.log
}

# Scan a folder without traversing the sub folders for git repositories
function createGitLogForFolder() {
	for entry in $1/*; do
		if [[ -d "$entry/.git" ]]; then
			createGitLog $entry
		fi
	done
	if [[ -d $1/.git ]]; then
		createGitLog $1
	fi
}

#(
	#cd $PROJECT_DIR
	#createGitLog de.almex.cascara.all
#)

mkdir -p $LOG_DIR

createGitLogForFolder "/c/development/cascara/cascara/core"
createGitLogForFolder "/c/development/cascara/deutsche-bahn"
createGitLogForFolder "/c/development/cascara/hhag"
combineGitLogs

gource ${GOURCE_OPTIONS} "${LOG_DIR}"/combined.log | "${FFMPEG_PATH}" ${FFMPEG_OPTIONS} "${GOURCE_WORK_DIR}/${PROJECT_NAME}.webm"