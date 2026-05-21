#!/bin/bash
#
# Grab a still frame from a video at a given timecode.
#
# Companion to 01-transcribe-and-diarize.sh: the transcript prints wall-clock
# times like  **[07:54:05 --> 07:54:17]** . This script takes one of those
# timecodes and pulls the matching frame out of the source video, translating
# wall-clock time back into a video-relative offset using the same recording
# start-time logic the transcription script uses.
#
# Usage:
#   ./02-grab-still.sh [-s START] [-r] <video> <timecode> [output.png]
#
#   <timecode>   HH:MM:SS[.mmm] | MM:SS | seconds   (default: a wall-clock time
#                copied straight from the transcript, e.g. 07:54:05)
#   -r           Raw mode: treat <timecode> as an offset from the START of the
#                video, not a wall-clock time. No translation is applied.
#   -s START     Recording start time, as epoch or "YYYY-MM-DD HH:MM:SS".
#                Must match whatever the transcript was generated with (the -t
#                value passed to 01-transcribe-and-diarize.sh). If omitted, the
#                start time is derived the same way that script does by default:
#                video file mtime minus its duration.
#
#   output.png   Optional. Defaults to <videobase>_<HHMMSS>.png next to the video.
#
# Requires: ffmpeg, ffprobe
#
set -e

RAW_MODE=0
FORCE_START_TIME=""

while getopts ":rs:" opt; do
  case "$opt" in
    r) RAW_MODE=1 ;;
    s) FORCE_START_TIME="$OPTARG" ;;
    *) echo "Usage: $0 [-s START] [-r] <video> <timecode> [output.png]"; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

VIDEO="$1"
TC="$2"
OUT="$3"

for cmd in ffmpeg ffprobe; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Error: $cmd is required."; exit 1; }
done

[ -z "$VIDEO" ] || [ -z "$TC" ] && { echo "Usage: $0 [-s START] [-r] <video> <timecode> [output.png]"; exit 1; }
[ -f "$VIDEO" ] || { echo "Error: file not found: $VIDEO"; exit 1; }

# ── Convert a HH:MM:SS[.mmm] / MM:SS / seconds string to total seconds ────────
to_seconds() {
  local t="$1" frac="" whole
  case "$t" in
    *.*) frac=".${t##*.}"; t="${t%.*}";;
  esac
  local IFS=':' parts=()
  read -ra parts <<< "$t"
  case "${#parts[@]}" in
    3) whole=$(( 10#${parts[0]}*3600 + 10#${parts[1]}*60 + 10#${parts[2]} ));;
    2) whole=$(( 10#${parts[0]}*60 + 10#${parts[1]} ));;
    1) whole=$(( 10#${parts[0]} ));;
    *) echo "Error: bad timecode: $1" >&2; exit 1;;
  esac
  echo "${whole}${frac}"
}

if [ "$RAW_MODE" -eq 1 ]; then
  # Timecode is already an offset from the start of the video.
  POS="$(to_seconds "$TC")"
else
  # Timecode is a wall-clock time; translate to a video-relative offset.
  DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$VIDEO")
  DURATION_INT=${DURATION%.*}

  if [ -n "$FORCE_START_TIME" ]; then
    if [[ "$FORCE_START_TIME" =~ ^[0-9]+$ ]]; then
      START_EPOCH="$FORCE_START_TIME"
    else
      START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$FORCE_START_TIME" "+%s" 2>/dev/null \
        || date -d "$FORCE_START_TIME" "+%s" 2>/dev/null \
        || { echo "Error: could not parse start time: $FORCE_START_TIME"; exit 1; })
    fi
  else
    FILE_MTIME=$(stat -f %m "$VIDEO" 2>/dev/null || stat -c %Y "$VIDEO" 2>/dev/null)
    START_EPOCH=$((FILE_MTIME - DURATION_INT))
  fi

  # Build the target epoch from the recording's local date + the wall-clock TC.
  START_DATE=$(date -r "$START_EPOCH" '+%Y-%m-%d' 2>/dev/null || date -d "@$START_EPOCH" '+%Y-%m-%d' 2>/dev/null)
  TC_WHOLE="${TC%.*}"; TC_FRAC=""
  [ "$TC" != "$TC_WHOLE" ] && TC_FRAC=".${TC##*.}"
  TARGET_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$START_DATE $TC_WHOLE" "+%s" 2>/dev/null \
    || date -d "$START_DATE $TC_WHOLE" "+%s" 2>/dev/null \
    || { echo "Error: could not parse timecode as wall-clock: $TC"; exit 1; })

  POS=$(( TARGET_EPOCH - START_EPOCH ))
  POS="${POS}${TC_FRAC}"

  case "$POS" in
    -*) echo "Error: timecode $TC is before the recording start ($(date -r "$START_EPOCH" '+%H:%M:%S' 2>/dev/null || date -d "@$START_EPOCH" '+%H:%M:%S'))." >&2
        echo "       Check -s / the -t value used during transcription." >&2
        exit 1;;
  esac
fi

# ── Default output name next to the video ────────────────────────────────────
if [ -z "$OUT" ]; then
  base="${VIDEO%.*}"
  tag=$(echo "$TC" | tr -d ':.' )
  OUT="${base}_${tag}.png"
fi

echo "Video : $VIDEO"
echo "Time  : $TC  ->  +${POS}s into video$([ "$RAW_MODE" -eq 1 ] && echo ' (raw)')"
echo "Output: $OUT"

# Input-side -ss is fast and frame-accurate enough for stills; -q:v 2 = high
# quality JPEG-equivalent; -update 1 + single frame writes one image.
ffmpeg -hide_banner -loglevel error -y \
  -ss "$POS" -i "$VIDEO" \
  -frames:v 1 -update 1 -q:v 2 \
  "$OUT"

echo "Done."
