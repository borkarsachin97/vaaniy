#!/usr/bin/env bash

# === Config ===
FIFO_HINDI="/tmp/vaaniy_hindi"     # Not used yet, echo only
FIFO_ENGLISH="/tmp/vaaniy_english" # Not used yet, echo only

# === Get clipboard ===
TEXT="$(xsel -p -o)"

# === Detect whole text language ===
HINDI_COUNT=$(echo "$TEXT" | grep -oP '[\x{0900}-\x{097F}]' | wc -l)
ENGLISH_COUNT=$(echo "$TEXT" | grep -oP '[A-Za-z]' | wc -l)

if [ "$HINDI_COUNT" -gt "$ENGLISH_COUNT" ]; then
  LANG="HINDI"
else
  LANG="ENGLISH"
fi

# === Split sentences ===
echo "$TEXT" | \
sed -E ':a;N;$!ba;s/\n/ /g; s/([.?!])([^0-9a-zA-Z])/&\n/g; s/([.?!]$)/&\n/g; $!s/$/\n/' | \
sed -z '$a\\n' | \
while IFS= read -r sentence; do
  # Trim whitespace
  sentence="$(echo "$sentence" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"
  [ -z "$sentence" ] && continue

  # === Send to the SAME pipe ===
  if [ "$LANG" = "HINDI" ]; then
    # echo "[HINDI] $sentence"
    echo "$sentence" > "$FIFO_HINDI"
  else
    # echo "[ENGLISH] $sentence"
    echo "$sentence" > "$FIFO_ENGLISH"
  fi
done

