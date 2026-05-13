#!/bin/bash

# ---- CONFIG ----
TOOL="mvc2stereo"
MODE="mv-hevc"   # dual-prores | sbs-prores | mv-hevc
EXTRA_ARGS=""

LOG_FILE="batch_$(date +%Y%m%d_%H%M%S).log"

# ---- INPUT FOLDER ----
INPUT_DIR="${1:-.}"

echo "Processing folder: $INPUT_DIR" | tee -a "$LOG_FILE"
echo "Mode: $MODE" | tee -a "$LOG_FILE"
echo "Log file: $LOG_FILE" | tee -a "$LOG_FILE"
echo "" | tee -a "$LOG_FILE"

shopt -s nullglob

for file in "$INPUT_DIR"/*.MTS "$INPUT_DIR"/*.mts "$INPUT_DIR"/*.M2TS "$INPUT_DIR"/*.m2ts "$INPUT_DIR"/*.MP4 "$INPUT_DIR"/*.mp4 "$INPUT_DIR"/*.MOV "$INPUT_DIR"/*.mov; do
    base="$(basename "$file")"
    name="${base%.*}"
    dir="$(dirname "$file")"

    # ---- Determine expected output ----
    case "$MODE" in
        "dual-prores")
            OUT1="$dir/${name}_L.mov"
            OUT2="$dir/${name}_R.mov"
            if [[ -f "$OUT1" && -f "$OUT2" ]]; then
                echo "⏭️  Skipping (exists): $base" | tee -a "$LOG_FILE"
                continue
            fi
            ;;
        "sbs-prores")
            OUT="$dir/${name}_SBS.mov"
            if [[ -f "$OUT" ]]; then
                echo "⏭️  Skipping (exists): $base" | tee -a "$LOG_FILE"
                continue
            fi
            ;;
        "mv-hevc")
            OUT="$dir/${name}_MVHEVC.mov"
            if [[ -f "$OUT" ]]; then
                echo "⏭️  Skipping (exists): $base" | tee -a "$LOG_FILE"
                continue
            fi
            ;;
    esac

    echo "========================================" | tee -a "$LOG_FILE"
    echo "Processing: $file" | tee -a "$LOG_FILE"
    echo "========================================" | tee -a "$LOG_FILE"

    "$TOOL" "$file" --mode "$MODE" $EXTRA_ARGS 2>&1 | tee -a "$LOG_FILE"

    if [ ${PIPESTATUS[0]} -ne 0 ]; then
        echo "❌ Error: $base" | tee -a "$LOG_FILE"
    else
        echo "✅ Done: $base" | tee -a "$LOG_FILE"
    fi

    echo "" | tee -a "$LOG_FILE"
done

echo "All files processed." | tee -a "$LOG_FILE"