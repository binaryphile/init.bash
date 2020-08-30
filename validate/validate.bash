# validate.bash - run validations in a subshell
(
  Here=$(dirname "$BASH_SOURCE")

  # load initutil so this can be sourced indpendently of init.bash
  ! (( ${Loaded[initutil]} )) && {
    source "$(dirname "$Here")"/lib/initutil.bash
    SplitSpace off
  }

  source $Here/lib/truth.bash

  source $Here/env.bash
  source $Here/cmds.bash
  source $Here/bash.bash
  source $Here/interactive.bash
  source $Here/login.bash

  source $Here/apps.bash
)
