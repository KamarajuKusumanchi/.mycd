function mycd()
{
    tmpDir="$PWD"
    echo "#"`date +%s`" $USER -> $@"  >> "$HISTFILE"
    #echo "$USER has exited $PWD for $@" >> "$HISTFILE"                                                   
    history >> ~/Dropbox/work/forever
    builtin cd "$@" # do actual cd                                                                        
    #if this directory is writable then write to directory-based history file                             
    #other write history in the usual home-based history file                                             
    touch "$PWD/.dir_bash_history" 2>/dev/null && export HISTFILE="$PWD/.dir_bash_history" || export HISTFILE="$HOME/.bash_history";
    echo "#"`date +%s`" $USER <- $OLDPWD" >> "$HISTFILE"
    #echo "$USER <- $OLDPWD" >> "$HISTFILE"                                                               
}
alias cd="mycd"
#initial shell opened                                                                                     
export HISTFILE="$PWD/.dir_bash_history"
#timestamp all history entries                                                                            
export HISTTIMEFORMAT="%h/%d - %H:%M:%S "
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend ## append, no clearouts                                                               
shopt -s histverify ## edit a recalled history line before executing                                      
shopt -s histreedit ## reedit a history substitution line if it failed                                    

## Save the history after each command finishes                                                           
## (and keep any existing PROMPT_COMMAND settings)                                                        
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"
