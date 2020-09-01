# apps.bash - load app settings from app dirs.
# test for existence of commands before loading.  allow ordering of loading by
# dependencies.

pushd $Root/apps >/dev/null

# list the app dirs, with ordering based on "deps" file in app dir
AppList=$(ListDir . | Filter IsDir | Filter IsApp | OrderByDependencies)

for App in $AppList; do
  # if "reload" was given, reload the environment as well
  { ShellIsLogin || [[ $1 == reload ]]; } && TestAndSource $App/env.bash

  # when loading initialization provided by the app (referenced in
  # [app]/init.bash), give it the expected settings with normal IFS and
  # globbing on (means our variables need quotes again)
  SplitSpace on
  Globbing on

  TestAndSource "$App"/init.bash

  SplitSpace off
  Globbing off

  TestAndSource $App/interactive.bash
  TestAndSource $App/cmds.bash
done

# clean up
unset -v AppList App
popd >/dev/null
