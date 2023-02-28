function mycd()
{
    # set -x

    # By default, the cd command is logged into the new history file.
    # But I want it in the old history file (for ctrl-r purposes).
    # As a work around, log it in the current history file.
    # Todo:- Is there a better way to achieve this?
    echo "cd $@" >> "$HISTFILE"
    builtin cd "$@" # do the actual cd

    terminal_type=`uname -s | cut -f 1 -d '-'`
    if [ "$terminal_type" = "MINGW64_NT" ]; then
        # using git bash.
	# here the usual [ -w "$PWD" ] , to check if the directory is
        # writable is not working. so, do it the hard way.
        touch $PWD/.dir_bash_history > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            export HISTFILE="$PWD/.dir_bash_history"
        else
            export HISTFILE="$HOME/.dir_bash_history"
        fi
    else
        # If the new directory is writable then write the history into a file under
        # it otherwise use $HOME
        if [ -w "$PWD" ]; then
            export HISTFILE="$PWD/.dir_bash_history"
        else
            export HISTFILE="$HOME/.dir_bash_history"
        fi
    fi

    # Clean up the HISTFILE in a given "minute range".
    # The idea here is to get the current minute and then check if that falls
    # in a given range.
    #
    # In the date command, I am using '%-M' to get the current minute instead
    # of '%M' so that the result is not padded by 0. We do not want the minute
    # value to start with zero since then it will be interpreted as an octal
    # number while doing number comparison. If the current minute is 08, it will
    # lead to errors such as
    #
    # bash: ((: 08: value too great for base (error token is "08")
    #
    # The reason for this error and a possible fix is given in
    # https://stackoverflow.com/questions/24777597/value-too-great-for-base-error-token-is-08
    #
    # But I decided to modify the date command itself to keep the downstream
    # code simple.
    #
    # Relevant lines from 'date --help'
    #
    # By default, date pads numeric fields with zeroes.
    # The following optional flags may follow '%':
    #
    #   -  (hyphen) do not pad the field
    current_minute=`date +'%-M'`
    clean_up_start_minute=40
    clean_up_end_minute=50
    if (( $current_minute >= $clean_up_start_minute )) &&
       (( $current_minute < $clean_up_end_minute )) ;
    then
        echo "cleaning up $HISTFILE"
        echo "number of lines before: $(wc -l $HISTFILE | cut -f 1 -d ' ')"
        # Here we remove the duplicates and only store the latest.
        # The command is adapted from
        # https://unix.stackexchange.com/questions/48713/how-can-i-remove-duplicates-in-my-bash-history-preserving-order
        # You can also run it manually whenever the HISTFILE becomes "bloated".
        tac $HISTFILE | awk '! x[$0]++' | tac > /tmp/tmpfile && "mv" -f /tmp/tmpfile $HISTFILE
        echo "number of lines after: $(wc -l $HISTFILE | cut -f 1 -d ' ')"
    fi
    # set +x
}

alias cd="mycd"
#initial shell opened
export HISTFILE="$PWD/.dir_bash_history"

# prevent duplicate entries of a single session from being saved to $HISTFILE.
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=1000000
export HISTFILESIZE=1000000
shopt -s histappend # append, no clearouts
# Save the history after each command finishes
# (and keep any existing PROMPT_COMMAND settings)
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Notes
# 1) Over time the HISTFILE may be "bloated" as the ignoredups and erasedups
# options only remove successive duplicates. To remove duplicates anywhere in
# the history but preserve the order, run
#   prune_history.sh
# 2) For new directories, we might want to "pre populate" history from a master
# file. To do that run
#   populate_history.sh
#  It uses $HOME/.dir_bash_history as the master history file.
