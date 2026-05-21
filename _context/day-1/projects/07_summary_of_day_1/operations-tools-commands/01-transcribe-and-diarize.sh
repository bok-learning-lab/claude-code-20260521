#!/bin/bash
#
# Simple transcription script with diarization
# Usage: transcribe_parallel <video_or_audio_file>
#
# Output: Creates a folder next to the input file with the same basename
#         e.g., /path/to/video.mov -> /path/to/video/
#
# Requires: ffmpeg, curl, jq
# Expects: OPENAI_API_KEY environment variable
#

set -e

# Configuration
MAX_CHUNK_DURATION=600  # 10 minutes in seconds
SILENCE_THRESHOLD_DB=-35
API_CALL_DELAY=0.5      # Seconds between launching parallel API calls

# Check dependencies
for cmd in ffmpeg ffprobe curl jq; do
  if ! command -v $cmd &> /dev/null; then
    echo "Error: $cmd is required but not installed."
    exit 1
  fi
done

# Check API key
if [ -z "$OPENAI_API_KEY" ]; then
  echo "Error: OPENAI_API_KEY environment variable is not set."
  exit 1
fi

# Parse arguments
FORCE_START_TIME=""

while getopts ":t:" opt; do
  case "$opt" in
    t) FORCE_START_TIME="$OPTARG" ;;
    *) echo "Usage: $0 [-t <start_time>] <video_or_audio_file>"; exit 1 ;;
  esac
done
shift $((OPTIND - 1))

INPUT_FILE="$1"

if [ -z "$INPUT_FILE" ]; then
  echo "Usage: $0 [-t <start_time>] <video_or_audio_file>"
  echo "  -t  Override recording start time. Accepts:"
  echo "      Unix epoch:          -t 1705329000"
  echo "      Date/time string:    -t \"2024-01-15 14:30:00\""
  exit 1
fi

if [ ! -f "$INPUT_FILE" ]; then
  echo "Error: File not found: $INPUT_FILE"
  exit 1
fi

# Get absolute path and compute output directory next to input file
INPUT_DIR=$(dirname "$INPUT_FILE")
BASENAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
OUTPUT_DIR="$INPUT_DIR/$BASENAME"

# Create output directory
mkdir -p "$OUTPUT_DIR"

AUDIO_FILE="$OUTPUT_DIR/${BASENAME}.mp3"

echo "=== Transcribe with Diarization ==="
echo "Input: $INPUT_FILE"
echo "Output: $OUTPUT_DIR"
echo ""

# Step 1: Extract/convert to audio
echo "[1/4] Extracting audio..."
ffmpeg -y -i "$INPUT_FILE" -vn -acodec libmp3lame -ab 128k "$AUDIO_FILE" 2>/dev/null
echo "      Created: $AUDIO_FILE"

# Step 2: Get duration and compute recording start time
DURATION=$(ffprobe -v quiet -show_entries format=duration -of csv=p=0 "$AUDIO_FILE")
DURATION_INT=${DURATION%.*}

# Get file mtime (end of recording) and compute start time
FILE_MTIME=$(stat -f %m "$INPUT_FILE" 2>/dev/null || stat -c %Y "$INPUT_FILE" 2>/dev/null)

if [ -n "$FORCE_START_TIME" ]; then
  # Accept raw epoch or a date string
  if [[ "$FORCE_START_TIME" =~ ^[0-9]+$ ]]; then
    START_EPOCH="$FORCE_START_TIME"
  else
    START_EPOCH=$(date -j -f "%Y-%m-%d %H:%M:%S" "$FORCE_START_TIME" "+%s" 2>/dev/null \
      || date -d "$FORCE_START_TIME" "+%s" 2>/dev/null \
      || { echo "Error: Could not parse start time: $FORCE_START_TIME"; exit 1; })
  fi
  echo "      (start time overridden)"
else
  START_EPOCH=$((FILE_MTIME - DURATION_INT))
fi

echo "[2/4] Audio duration: ${DURATION_INT}s"
echo "      Recording start: $(date -r $START_EPOCH '+%Y-%m-%d %H:%M:%S' 2>/dev/null || date -d @$START_EPOCH '+%Y-%m-%d %H:%M:%S' 2>/dev/null)"

# Step 3: Chunk if needed
CHUNKS=()
if [ "$DURATION_INT" -gt "$MAX_CHUNK_DURATION" ]; then
  echo "      Splitting into ${MAX_CHUNK_DURATION}s chunks..."

  ffmpeg -y -i "$AUDIO_FILE" -f segment -segment_time $MAX_CHUNK_DURATION -c copy \
    "$OUTPUT_DIR/${BASENAME}_chunk_%03d.mp3" 2>/dev/null

  # Find all chunks
  for chunk in "$OUTPUT_DIR/${BASENAME}_chunk_"*.mp3; do
    if [ -f "$chunk" ]; then
      CHUNKS+=("$chunk")
    fi
  done

  echo "      Created ${#CHUNKS[@]} chunks"
else
  CHUNKS=("$AUDIO_FILE")
  echo "      No chunking needed"
fi

# Step 4: Transcribe each chunk (in parallel)
echo "[3/4] Transcribing with diarization (parallel)..."

# Function to process a single chunk
process_chunk() {
  local chunk="$1"
  local chunk_index="$2"
  local output_dir="$3"
  local silence_threshold="$4"

  CHUNK_NAME=$(basename "$chunk")
  RESULT_FILE="$output_dir/.chunk_${chunk_index}_result.json"

  # Check audio level
  PEAK_DB=$(ffmpeg -i "$chunk" -af volumedetect -f null - 2>&1 | grep max_volume | sed 's/.*max_volume: //' | sed 's/ dB//')

  if [ -n "$PEAK_DB" ]; then
    PEAK_INT=${PEAK_DB%.*}
    if [ "$PEAK_INT" -lt "$silence_threshold" ]; then
      echo "      [$CHUNK_NAME] Skipping (silent: ${PEAK_DB} dB)"
      echo '{"skipped": true, "segments": []}' > "$RESULT_FILE"
      return
    fi
  fi

  echo "      [$CHUNK_NAME] Calling API..."

  # Call OpenAI API
  RESPONSE=$(curl -s -X POST "https://api.openai.com/v1/audio/transcriptions" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -F "file=@$chunk" \
    -F "model=gpt-4o-transcribe-diarize" \
    -F "response_format=diarized_json" \
    -F "chunking_strategy=auto")

  # Check for error
  if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
    ERROR_MSG=$(echo "$RESPONSE" | jq -r '.error.message')
    echo "      [$CHUNK_NAME] Error: $ERROR_MSG"
    echo '{"error": true, "segments": []}' > "$RESULT_FILE"
    return
  fi

  # Save result
  echo "$RESPONSE" > "$RESULT_FILE"
  SEGMENT_COUNT=$(echo "$RESPONSE" | jq '.segments // [] | length')
  echo "      [$CHUNK_NAME] Done ($SEGMENT_COUNT segments)"
}

export -f process_chunk
export OPENAI_API_KEY

# Launch all chunks in parallel with staggered start
echo "      Launching ${#CHUNKS[@]} parallel jobs (${API_CALL_DELAY}s apart)..."
CHUNK_INDEX=0
PIDS=()

for chunk in "${CHUNKS[@]}"; do
  process_chunk "$chunk" "$CHUNK_INDEX" "$OUTPUT_DIR" "$SILENCE_THRESHOLD_DB" &
  PIDS+=($!)
  ((CHUNK_INDEX++)) || true

  # Stagger the launches to avoid rate limits
  if [ "$CHUNK_INDEX" -lt "${#CHUNKS[@]}" ]; then
    sleep "$API_CALL_DELAY"
  fi
done

# Wait for all jobs to complete
echo "      Waiting for all jobs to finish..."
for pid in "${PIDS[@]}"; do
  wait "$pid" 2>/dev/null || true
done

echo "      All jobs complete. Merging results..."

# Merge results in order
ALL_SEGMENTS="[]"
CHUNK_INDEX=0

for chunk in "${CHUNKS[@]}"; do
  CHUNK_NAME=$(basename "$chunk")
  RESULT_FILE="$OUTPUT_DIR/.chunk_${CHUNK_INDEX}_result.json"

  if [ -f "$RESULT_FILE" ]; then
    # Check if skipped or error
    if jq -e '.skipped or .error' "$RESULT_FILE" > /dev/null 2>&1; then
      ((CHUNK_INDEX++)) || true
      rm -f "$RESULT_FILE"
      continue
    fi

    # Save chunk JSON (for debugging/reference)
    CHUNK_JSON="$OUTPUT_DIR/${CHUNK_NAME%.mp3}.json"
    cp "$RESULT_FILE" "$CHUNK_JSON"

    # Extract and offset segments
    SEGMENTS=$(jq '.segments // []' "$RESULT_FILE")
    CHUNK_OFFSET=$((CHUNK_INDEX * MAX_CHUNK_DURATION))
    CHUNK_NUM=$((CHUNK_INDEX + 1))
    ADJUSTED_SEGMENTS=$(echo "$SEGMENTS" | jq --argjson offset "$CHUNK_OFFSET" --argjson chunkNum "$CHUNK_NUM" '
      ["A","B","C","D","E","F","G","H","I","J","K","L"] as $letters |
      (map(.speaker // "") | unique | sort | to_entries |
        map({key: .value, value: ($letters[.key] // "?")}) | from_entries) as $speakerMap |
      map(. + {
        chunk: $chunkNum,
        start: (.start + $offset),
        end: (.end + $offset),
        speaker: (if (.speaker != null and .speaker != "") then "\($chunkNum)-\($speakerMap[.speaker] // .speaker)" else .speaker end)
      })
    ')

    ALL_SEGMENTS=$(echo "$ALL_SEGMENTS" "$ADJUSTED_SEGMENTS" | jq -s 'add')

    # Clean up temp file
    rm -f "$RESULT_FILE"
  fi

  ((CHUNK_INDEX++)) || true
done

# Step 5: Generate output files
echo "[4/4] Generating output files..."

# Combined JSON (with absolute timestamps added)
COMBINED_JSON="$OUTPUT_DIR/${BASENAME}_diarize.json"
echo "$ALL_SEGMENTS" | jq --argjson startEpoch "$START_EPOCH" '{
  startEpoch: $startEpoch,
  segments: [.[] | . + {
    absoluteStartEpoch: ($startEpoch + (.start | floor)),
    absoluteEndEpoch: ($startEpoch + (.end | floor))
  }]
}' > "$COMBINED_JSON"
echo "      JSON: $COMBINED_JSON"

# Markdown (with wall-clock times)
# We need to format epochs as local time - jq can't do this natively, so we use a helper
COMBINED_MD="$OUTPUT_DIR/${BASENAME}_diarize.md"

# Generate markdown by processing each segment
echo "$ALL_SEGMENTS" | jq -r --argjson startEpoch "$START_EPOCH" '
  .[] |
  "\(.chunk)|\($startEpoch + (.start | floor))|\($startEpoch + (.end | floor))|\(.speaker // "")|\(.text)"
' | while IFS='|' read -r chunk startEpoch endEpoch speaker text; do
  if [ "$chunk" != "${LAST_CHUNK-}" ]; then
    [ -n "${LAST_CHUNK-}" ] && echo ""
    echo "## Chunk $chunk"
    echo ""
    LAST_CHUNK="$chunk"
  fi
  startTime=$(date -r "$startEpoch" '+%H:%M:%S' 2>/dev/null || date -d "@$startEpoch" '+%H:%M:%S' 2>/dev/null)
  endTime=$(date -r "$endEpoch" '+%H:%M:%S' 2>/dev/null || date -d "@$endEpoch" '+%H:%M:%S' 2>/dev/null)
  if [ -n "$speaker" ]; then
    echo "**[$startTime --> $endTime]** **$speaker:** $text"
  else
    echo "**[$startTime --> $endTime]** $text"
  fi
done > "$COMBINED_MD"
echo "      Markdown: $COMBINED_MD"

# Summary
TOTAL_SEGMENTS=$(echo "$ALL_SEGMENTS" | jq 'length')
echo ""
echo "=== Done ==="
echo "Total segments: $TOTAL_SEGMENTS"
echo "Output files:"
echo "  - $COMBINED_JSON"
echo "  - $COMBINED_MD"