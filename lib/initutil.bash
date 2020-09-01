# initutil.bash - useful functions for init.bash

shopt -s expand_aliases

# functions before this library
FunctionList=$(compgen -A function | sort)

Filter () {
  local item

  while read -r item; do
    $1 $item && echo $item
  done
}

Globbing () {
  case $1 in
    on  ) set +o noglob;;
    off ) set -o noglob;;
  esac
}

IsApp () {
  local dir=$1

  IsFile $dir/detect.bash && {
    source $dir/detect.bash
    return
  }

  IsCmd $dir
}

IsCmd () {
  type $1 &>/dev/null
}

IsDir () {
  [[ -d $1 ]]
}

IsFile () {
  [[ -r $1 ]]
}

ListDir () { (
  local items=()

  cd $1
  Globbing on
  items=( * )
  echo "${items[*]}"
) }

OrderByDependencies () {
  local -A satisfied=()

  ORDER_BY_DEPENDENCIES
}

ORDER_BY_DEPENDENCIES () {
  local app dep

  while read -r app; do
    (( ${satisfied[$app]} )) && continue

    ! IsFile $app/deps && {
      echo $app
      satisfied[$app]=1
      continue
    }

    for dep in $(ORDER_BY_DEPENDENCIES $(<$app/deps)); do
      (( ${satisfied[$dep]} )) && continue
      echo $dep
      satisfied[$dep]=1
    done

    echo $app
    satisfied[$app]=1
  done
}

ShellIsInteractive () {
  [[ $- == *i* ]]
}

ShellIsInteractiveAndLogin () {
  ShellIsInteractive && ShellIsLogin
}

ShellIsLogin () {
  ! (( ENV_SET ))
}

SplitSpace () {
  case $1 in
    on  ) IFS=$' \t\n';;
    off ) IFS=$'\n'   ;;
  esac
}

alias TestAndSource='{ read -r Candidate; IsFile $Candidate && source $Candidate; unset -v Candidate; } <<<'

# vars and functions to cleanup
Functions=( $(comm -13 <(echo "$FunctionList") <(compgen -A function | sort)) )
Vars+=( Vars Functions )

unset -v FunctionList
