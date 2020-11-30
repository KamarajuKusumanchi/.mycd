#! /usr/bin/env bash

# Remove all the duplicates but preserve the order of commands in the HISTFILE.
#
# Adapted from
# https://unix.stackexchange.com/questions/48713/how-can-i-remove-duplicates-in-my-bash-history-preserving-order
tac $HISTFILE | awk '! x[$0]++' | tac > /tmp/tmpfile && "mv" -fv /tmp/tmpfile $HISTFILE

