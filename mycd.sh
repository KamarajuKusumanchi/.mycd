function mycd()
{
    # set -x

    # By default, the cd command is logged into the new history file.
    # But I want it in the old history file (for ctrl-r purposes).
    # As a work around, log it in the current history file.
    # Todo:- Is there a better way to achieve this?
    echo "cd $@" >> "$HISTFILE"
    builtin cd "$@" # do the actual cd
    # If the new directory is writable then write the history into a file under
    # it otherwise use $HOME
    if [ -w "$PWD" ]; then
        export HISTFILE="$PWD/.dir_bash_history"
    else
        export HISTFILE="$HOME/.dir_bash_history"
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

# Note:- Overtime the HISTFILE may be "bloated" as the ignoredups and erasedups
# options only remove successive duplicates. To remove duplicates anywhere in
# the history but preserve the order, run
# tac $HISTFILE | awk '! x[$0]++' | tac > /tmp/tmpfile && "mv" -fv /tmp/tmpfile $HISTFILE
