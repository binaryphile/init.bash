# interactive.bash - settings for any interactive session
# use these for things that you do at the prompt

# ========
# Examples
# ========

# # use vi keybindings for command-line editing
# set -o vi

# # tell readline how to behave (INPUTRC is not an environment variable)
# INPUTRC=$HOME/dotfiles/bash/inputrc

# # history settings - create an eternal bash history of all commands.
# # merge the history from all sessions into one on session exit.
# # still allow separate sessions to keep their own history while live.
# historymerge () {
#   nl <"$HOME"/.bash_history |
#     sort -k2 |
#     tac |
#     uniq -f1 |
#     sort -n |
#     cut -f2 >"$HOME"/.bash_history_new
#     mv "$HOME"/.bash_history_new "$HOME"/.bash_history
# }
#
# trap historymerge EXIT
#
# shopt -s histappend
# HISTCONTROL=ignorespace:erasedups
# HISTIGNORE=l:l[asl]:ltr:ps:[bf]g:history
# HISTTIMEFORMAT='%F %T '
# PROMPT_COMMAND=${PROMPT_COMMAND}${PROMPT_COMMAND+; }'history -a; echo "$$ $USER $(history 1)" >>"$HOME"/.bash_eternal_history'
