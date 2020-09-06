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

init.bash is the main script. Install it by symlinking ~/.bashrc and
~/.bash\_profile.

Settings
--------

The settings folder contains your actual settings. It's broken into
several files.

General settings files are loaded after app-specific ones, in case an
app wants an initialization file sourced that might override one of your
settings.  Here, "general" means anything not specific to one of the
installed applications.  Having your general settings come after app
code gives you control over the final state of settings.

The one exception is env.bash, which loads first so you can set PATH.
You may need PATH to include your local bin directory in order for your
apps to be detected so their settings are loaded. Note, it is not so you
can set environment variables to configure apps. Those go in the
respective env.bash files in the app subdirectories.

init.bash loads settings in the following order:

-   **env.bash** - general environment variables such as PATH

-   **app settings** - everything from the **/apps** directory

-   **base.bash** - general bash settings, anything not covered by other
    files

-   **cmds.bash** - general functions and aliases

-   **interactive.bash** - general interactive-only settings like
    history, prompt, etc.

-   **login.bash** - one-time login tasks

Each of these is loaded under the proper circumstances, shown in the
table below.

In the "when loaded" column in the table, "interactive" means a
command-prompt session, as opposed to a remote ssh command (e.g.
`ssh me@remotehost ls`) or `bash -c`.

Likewise, "login" means a shell which has inherited your environment.
Typically this is a normal bash login shell (`-bash` or `bash --login`)
but any environment which hasn't received the your environment will be
treated as a login. This allows remote ssh commands, which don't run a
login shell, to load the environment.

| File             | When Loaded            |
|------------------|------------------------|
| base.bash        | always                 |
| cmds.bash        | always                 |
| env.bash         | login                  |
| login.bash       | interactive login only |
| interactive.bash | interactive shell      |

Apps
----

The file structure for the apps directory follows:

```
apps
├── app1
│   ├── cmds.bash
│   ├── deps
│   ├── detect.bash
│   ├── env.bash
│   ├── init-app.bash
│   └── interactive.bash
└── app2
    └── ...
```

**deps** and **detect.bash** are typically not required, and the rest
are all optional (do not need to be there for init to work).

The apps folder contains a subdirectory for each app you want to
configure. You can have any number of apps configured, but only those
which are detected by init.bash will be loaded.

The normal detection is to simply look for a command available on the
path which matches the name of the directory. If you add a new command,
just name the directory after the command and it will be detected.

Some applications don't have a command-line command to detect. In that
case, you might need to check for the existence of a file or directory,
or another arbitrary test. In such a case, you can create a file called
**detect.bash** in the app's folder which has a detection expression,
such as `[[ -d /some/app/directory ]]`. If there is a detect.bash
present, init will use its result to determine whether to load the app's
settings.

Each app's directory can have the following settings files, loaded in
this order.  Typically you will only need some combination of env.bash,
init-app.bash and cmds.bash, unless you have bash completions.

-   **env.bash** - app-specific environment variables - loaded first so
    you can configure the app if it depends on env vars

-   **init-app.bash** - to source any app-specific code

-   **cmds.bash** - app-specific functions and aliases

-   **interactive.bash** - interactive-only settings, such as bash
    completions

Again, these files are loaded only under the appropriate circumstances.

The last file available for apps is **deps**. You shouldn't normally
need it. However, occasionally two apps might clash over a variable such
as PROMPT\_COMMAND. Normally, app settings are loaded in an unspecified
order, which means if one app sets an entire variable's contents, it
will overwrite the value set by another app for the same variable. If
the unfriendly app happens to be loaded second, that's too bad for the
other.

deps allows you to specify the directory name of another app to force
that app to be loaded first. All it needs is the name of the directory
as it appears under apps/. If there are multiple dependencies, you can
list them one per line in a list.

init is smart enough to detect transitive dependencies, should it come
to that (a dependency with its own deps file). It is not smart enough,
however, to detect dependency cycles, nor to verify that what appears in
the list correctly specifies another app. Bear that in mind, but I doubt
you'll run into a situation where those things matter.

Other Notes
-----------

init.bash was the result of frustrations from having to understand how
bash was started in a large variety of situations. There are a number of
diagrams mapping this out, but even if you go by the docs, you aren't
going to get [the whole picture].

I was frustrated by the fact that beginners need the difference between
bash\_profile and bashrc explained carefully because they are
nonintuitive, starting with their names. I was also frustrated that I
couldn't properly anticipate what was going to happen when I ssh'ed a
remote command or sudo'ed with varying options. I just wanted to stop
having to think about it.

I experimented with varying approaches. The first was to ensure,
similarly to how bash\_profile needs to source bashrc, that I sourced
bash\_profile from bashrc (with loop detection of course). That really
doesn't work, because it is both confusing as well as making the
environment variables defeat interactive change by the user without some
added cleverness.

I finally realized that the model of using two files itself was too
limiting to accomplish what I wanted (consistency), and so I simply
merged the files together and symlinked to one of them. It required
conditionals to detect the various bash modes with sections for the
appropriate settings, but it worked much better. Unfortunately, it
wasn't very modular and no one but me could read it. It was a mess, even
with heavy commentary.

init is my third revision. I'm much happier with it. The filenames
clearly indicate what you should be concerned with putting in them. They
are separate from the logic, so they are easy to read. I've created some
utility functions which enhance the readability quite a bit compared to
the original formulations of many of the statements, and reduce the
reliance on variables (and the accompanying unset statements).

If you like init, feel free to hack on it. I will probably not take many
submissions, but it is meant to be maintainable enough that you can suit
it to your purposes. It's a complete basis, but only a basis.

A few notes about my functions. The first is that I employ
UpperCamelCase for naming functions (and variables). Because init code
has to play nice with whatever your apps provide, that is a simple and
readable way to guarantee namespacing away from other code. Nobody uses
it but me! (and now, perhaps you) It only takes a moment to get used to
it once you understand the reason for it. Believe it or not, I have
experienced name collisions in my init files, and have tried out a
number conventions (long names, underscores) to combat it, but this is
the simplest and most readable of them.

Another note is that you'll notice I don't quote my variables. That's
not by mistake. Rather then quote everything, I prefer to turn off
bash's features that force you to quote in the first place. This is
word-splitting on space, and globbing. I employ two functions,
SplitSpace and Globbing, to toggle those features, but all they are
doing is changing IFS to newline and running shopt, respectively.
However, after init is finished, space and globbing are turned back on
for a normal shell experience.

There are two places in your files where you need to be aware of the
status of word-splitting and globbing. The first is in your functions
and aliases. While the two features are turned off in init, your
commands will run in the normal shell environment where the features
have been reenabled. Write your commands with that in mind, i.e. use
quotes around variable expansions. The second place is in any
init-app.bash file. Because they are for sourcing third-party code, the
two features are reenabled before calling init-app.bash, then turned
back off when control is handed back to init.

The last note is that the library of utility functions
(**lib/initutil.bash**) has its functions removed at the end of init so
that they don't stick around in your shell session. The code knows to
diff the names of the functions before and after the library is sourced,
so it knows all of the functions defined in the library. At the end of
init, it unsets all of these functions. If you want to add a function to
the library, you can do so without worrying about having to clean it up;
it will be cleaned up for you. If you don't want it cleaned up, don't
put it in the library.

  [the whole picture]: https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html
