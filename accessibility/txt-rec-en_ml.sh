#!/usr/bin/env bash

# === Config ===
FIFO_MAL="/tmp/vaaniy_malayalam"     
FIFO_ENGLISH="/tmp/vaaniy_english" 

# === Get clipboard ===
TEXT="$(xsel -p -o)"

# === Detect whole text language ===
# Malayalam Unicode block: U+0D00–U+0D7F
MAL_COUNT=$(echo "$TEXT" | grep -oP '[\x{0D00}-\x{0D7F}]' | wc -l)
ENGLISH_COUNT=$(echo "$TEXT" | grep -oP '[A-Za-z]' | wc -l)

if [ "$MAL_COUNT" -gt "$ENGLISH_COUNT" ]; then
  LANG="MAL"
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
  if [ "$LANG" = "MAL" ]; then
    echo "[MAL] $sentence"
    # echo "$sentence" > "$FIFO_MAL"
  else
    echo "[ENGLISH] $sentence"
    # echo "$sentence" > "$FIFO_ENGLISH"
  fi
done

