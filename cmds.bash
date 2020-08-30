# cmds.bash - general (not app-specific) aliases and functions.
# aliases are turned on for non-interactive shells in lib/initutil.bash

# ========
# Examples
# ========

# alias validate-bash='source ~/dotfiles/bash/validate/validate.bash'

# # by convention, don't overwrite the names of existing commands such as
# # "ls"...use an alternative name, such as "l", instead
# alias l="ls -hF $([[ $OSTYPE == darwin* ]] && echo -G || echo --color=auto)"
# alias ll='l -l'
# alias la='l -la'
# alias ltr='l -ltr'

# # path pretty prints the path
# alias path='echo "${PATH//:/$'\n'}"'

# # become switches users
# # works on just about any system for any type of target user, even non-login
# # accounts
# become () {
#   sudo -Hu "$1" bash -c 'cd; exec bash -l'
# }

# # runas runs a command as another user
# runas () {
#   sudo -u "$1" bash -l -c "$2"
# }

# # psaux is ps aux if it searched for process names
# psaux () {
#   pgrep -f "$@" | xargs ps -fp 2>/dev/null
# }
