#! /usr/bin/env bash

# Prepend the current history file with the one in $HOME and remove all the
# duplicates but preserve the order of commands.
#
# Adapted from
# https://unix.stackexchange.com/questions/48713/how-can-i-remove-duplicates-in-my-bash-history-preserving-order
master_histfile="$HOME/.dir_bash_history"
touch $HISTFILE    # create if it does not already exist
tac $HISTFILE $master_histfile | awk '! x[$0]++' | tac > /tmp/tmpfile && "mv" -fv /tmp/tmpfile $HISTFILE
