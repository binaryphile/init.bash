init.bash - Bash Init File Replacement
======================================

Bash's regular initialization files, **~/.bashrc** and
**~/.bash\_profile** are a bit of a hack.  They are only two files, but
they serve several different purposes:

-   **environment variables** - load environment variables once, that
    are then inherited by child processes, while allowing the user to
    interactively modify them in child shells and let the modified
    values propagate.

-   **command definition** - enable definition of custom aliases and
    functions.  Most users alias `ls` into something more friendly, for
    example.

-   **login tasks** - run interactive or "slow" shell-related tasks once
    at the beginning of a user's session.  The `fortune` command is one
    example, but you might do something like automatically bring up a
    vpn connection to a remote service.  Not the kind of thing you want
    performed every time you open a new terminal.

-   **general configuration** - configure bash settings you want for all
    shells, interactive or otherwise, such as setting the umask
    filesystem permission mask.

-   **interactive settings** - settings which only apply to terminal
    sessions where you interact with a prompt, such as setting a fancy
    prompt that uses color and shows git status.  Normally such settings
    won't hurt non-interactive shells, but if it's just as easy to not
    load them, why should they be when they aren't needed?

Knowing which file to put each kind of setting in takes a bit of
experience.  However, as old and venerable as these files are, they can
still be surprising even when you know what you are doing.

For example, it's easy to get excited about the possibility of doing
remote management when you learn that ssh can send individual commands:
`ssh me@remotehost ls`.  However, try running something from your home
bin directory, or one of your aliases and you'll get "command not
found".  Why?

The reason is that there are many ways of arriving at a bash session and
they trigger loading of .bashrc and .bash_profile differently.  A quick
google search for a graphic of the decision tree bash performs when
deciding which file to load is remarkably complex.  In the end, the
process doesn't map perfectly to just two files, at least not without
additional help in the form of logic within the init files themselves.

Enter init.bash
---------------

If you've gotten this far, I imagine that like me, you have a fairly
complex set of init files.  I also imagine that you deal with multiple
systems and maybe even platforms, with varying levels of control over
them.  Some systems have all of your command line toys, while others are
more spartan and may not provide sudo access.  **init.bash** handles all
of these by doing a few things well:

-  **one entrypoint** - init.bash is the same file no matter which way
   bash has been started.  ~/.bashrc and ~/.bash\_profile (and
   ~/.profile, if you want) are symlinked to one script, init.bash.
   Instead of worrying about how bash was started, you only worry about
   which of the categories I outlined at the beginning applies to your
   setting.  init.bash has the intelligence to sort out the rest.

-  **separate, well-named settings files** - environment variables go in
   **env.bash**.  Interactive settings go in **interactive.bash**.
   Login tasks go in **login.bash**, etc.  No mixing of init's
   intelligence code with the settings, which keeps the settings files
   simple.  Just settings.

-   
