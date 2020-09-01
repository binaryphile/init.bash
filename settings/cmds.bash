# cmds.bash - general (not app-specific) aliases and functions.

# ========
# Examples
# ========

# # by convention, don't overwrite the names of existing commands such as
# # "ls"...use an alternative name, such as "l", instead
# alias l="ls -hF $([[ $OSTYPE == darwin* ]] && echo -G || echo --color=auto)"
# alias ll='l -l'
# alias la='l -la'
# alias ltr='l -ltr'

# # path pretty prints the path
# alias path='echo "${PATH//:/$'\n'}"'

# # psaux is ps aux if it searched for process names
# psaux () {
#   pgrep -f "$@" | xargs ps -fp 2>/dev/null
# }
