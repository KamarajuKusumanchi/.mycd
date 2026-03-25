#! /usr/bin/env bash

# script to merge two bash history files and remove duplicates using history
# command.
# spec:
#   * The history files might have multiline commands with heredocs. They need
#     to be handled.
# usage: $github/.mycd/populate_history_v2.sh

set -eu

MASTER_HISTORY="$HOME/.dir_bash_history"
LOCAL_HISTORY="$HISTFILE"
BACKUP_FILE="${LOCAL_HISTORY}_asof_$(date +%Y%m%d_%H%M%S)"

if [ ! -f "$MASTER_HISTORY" ]; then
  touch "$MASTER_HISTORY"
fi
echo "Master history file is $MASTER_HISTORY."

if [ ! -f "$LOCAL_HISTORY" ]; then
  touch "$LOCAL_HISTORY"
fi
echo "Local history file is $LOCAL_HISTORY."

echo "Backing up local history file."
cp -v "$LOCAL_HISTORY" "$BACKUP_FILE"

# Clear the current history list
history -c

# Read the master history
if [ -s "$MASTER_HISTORY" ]; then
  history -r "$MASTER_HISTORY"
  #  echo "Read $(wc -l < "$MASTER_HISTORY") lines from $MASTER_HISTORY."
  echo "Read $(wc -l < "$MASTER_HISTORY") lines from master history file."
fi

# Read local history
if [ -s "$LOCAL_HISTORY" ]; then
  history -r "$LOCAL_HISTORY"
  # echo "Read $(wc -l < "$LOCAL_HISTORY") lines from $LOCAL_HISTORY."
  echo "Read $(wc -l < "$LOCAL_HISTORY") lines from local history file."
fi

# Write the merged history
TEMP_FILE="$LOCAL_HISTORY.tmp"
history -w "$TEMP_FILE"

# Remove duplicates while preserving order (keeping last occurrence)
tac "$TEMP_FILE" | awk '! seen[$0]++' | tac > "$LOCAL_HISTORY"

rm -f "$TEMP_FILE"
#echo "Prepended $LOCAL_HISTORY with $MASTER_HISTORY and removed duplicates while preserving order."
echo "Prepended local history file with master history and removed duplicates while preserving order."
#echo "$LOCAL_HISTORY now has $(wc -l < "$LOCAL_HISTORY") lines."
echo "Local history file now has $(wc -l < "$LOCAL_HISTORY") lines."
