init.bash - Bash Init File Replacement
======================================

Bash's regular initialization files, **~/.bashrc** and
**~/.bash\_profile** are a bit of a hack. They are only two files, but
they serve several different purposes:

-   **environment variables** - load environment variables once, that
    are then inherited by child processes, while allowing the user to
    interactively modify them in child shells and let the modified
    values propagate.

-   **command definition** - enable definition of custom aliases
    and functions. Most users alias `ls` into something more friendly,
    for example.

-   **login tasks** - run interactive or "slow" shell-related tasks once
    at the beginning of a user's session. The `fortune` command is one
    example, but you might do something like automatically bring up a
    vpn connection to a remote service. Not the kind of thing you want
    performed every time you open a new terminal.

-   **general configuration** - configure bash settings you want for all
    shells, interactive or otherwise, such as setting the umask
    filesystem permission mask.

-   **interactive settings** - settings which only apply to terminal
    sessions where you interact with a prompt, such as setting a fancy
    prompt that uses color and shows git status. Normally such settings
    won't hurt non-interactive shells, but if it's just as easy to not
    load them, why should they be when they aren't needed?

Knowing which file to put each kind of setting in takes a bit of
experience. However, as old and venerable as these files are, they can
still be surprising even when you know what you are doing.

For example, it's easy to get excited about the possibility of doing
remote management when you learn that ssh can send individual commands:
`ssh me@remotehost ls`. However, try running something from your home
bin directory, or one of your aliases and you'll get "command not
found". Why?

The reason is that there are many ways of arriving at a bash session and
they trigger loading of .bashrc and .bash\_profile differently. A quick
google search for a graphic of the decision tree bash performs when
deciding which file to load is remarkably complex. In the end, the
process doesn't map perfectly to just two files, at least not without
additional help in the form of logic within the init files themselves.

Enter init.bash
---------------

If you've gotten this far, I imagine that like me, you have a fairly
complex set of init files. I also imagine that you deal with multiple
systems and probably multiple platforms as well, with varying levels of
control over them. Some systems have all of your command line toys,
while others have a different assortment, or may not provide even
provide sudo access to install your preferred tools. **init.bash**
handles all of these by doing a few things well:

-   **one entrypoint** - init.bash is the same file no matter which way
    bash has been started. ~/.bashrc and ~/.bash\_profile (and
    ~/.profile, if you want) are symlinked to one script, init.bash.
    Instead of worrying about how bash was started, you only worry about
    which of the categories I outlined at the beginning applies to
    your setting. init.bash has the intelligence to sort out the rest.

-   **separate, well-named settings files** - environment variables go
    in **env.bash**. Interactive settings go in **interactive.bash**.
    Login tasks go in **login.bash**, etc. No mixing of init's
    intelligence code with the settings, which keeps the settings
    files simple. Just settings.

-   **modular** - settings specific to each app go together into their
    own folder. If they don't apply to a particular machine, they
    aren't loaded. If you get rid of an app, get rid of all of its
    settings by removing its folder with a single `rm -rf`.

Project Structure
-----------------

The following is the project folder structure. "apps" refer to any
command-line tool or application that you have installed on the machine.
Typically such apps might require environment variables and/or some form
of app-provided initialization script. You may also have aliases or
functions you want to create related to that app.

```
init.bash
├── apps        # app-specific settings folders
├── init.bash   # the primary script
├── lib         # supporting functions
└── settings    # general bash settings files
```

init.bash
---------

init.bash loads settings in the following order. Here, "general" means
anything not specific to one of the installed applications.

-   **settings/env.bash** - general environment variables such as PATH

-   **app settings** - everything from the **/apps** directory

-   **settings/base.bash** - general bash settings, anything not covered
    by other files

-   **settings/cmds.bash** - general functions and aliases

-   **settings/interactive.bash** - general interactive-mode settings
    like history, prompt, etc.

-   **settings/login.bash** - one-time login tasks

Each of these is loaded under the proper circumstances:

| File             | When Loaded       |
|------------------|-------------------|
| base.bash        | always            |
| cmds.bash        | always            |
| env.bash         | on login          |
| login.bash       | on login          |
| interactive.bash | interactive shell |
