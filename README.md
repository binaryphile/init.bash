init.bash - Bash Init File Replacement
======================================

Why replace **.bashrc** and **.bash\_profile**?

Have you ever been confused about which init file a particular setting
belongs in?

Have you tried sending a remote command with "ssh \[host\] \[command\]",
only to have it fail due to an environment variable or alias not being
found?

Would you like maintenance of your files to be easier and more sensible?

These may be minor annoyances, but as your files grow in complexity they
can become a real bother. They are symptoms of the poor mapping of the
two init files to the functions they serve. **init.bash** (hereafter
just *init*) solves these problems with better naming, organization and
intelligence.

To use init, you symlink both .bashrc as well as .bash\_profile to
**init.bash**. init takes care of determining which settings should be
loaded based on how bash is being invoked, whether it is a local console
session, ssh or otherwise.

Features
--------

-   **organization** - different types of settings are categorized and
    appear in well-named individual files

-   **consistency across invocation methods** - all of the settings
    appropriate for bash's invocation method are loaded (interactive,
    login, etc.) - get your environment variables when invoking a remote
    command via ssh, for example.

-   **modularity** - initialization specific to any local software
    package (such as **git** aliases or **nvm** environment variables)
    is isolated in its own set of files

-   **app detection** - local apps are detected before loading
    their settings. If one machine doesn't have a particular package,
    its settings will not be loaded. Simple dependency ordering is
    provided as well.

-   **validation** - (optional) if you like Test-Driven Development,
    this is TDD for bash files. Create a settings test, see it fail and
    then get it to pass with the desired settings. Checked
    automatically, once per login session.

-   **maintainability** - well-named functions and variables, where
    necessary, make the code readable. All of which evaporates without a
    trace at the end of initialization so as not to clutter the shell.

Installation and Usage
----------------------

The files in this directory form the basis for init. To use them, copy
to your own dotfile repository and customize for your environment. Then
symlink **~/.bashrc** and **~/.bash\_profile** to init.bash.

The easiest way to start is to copy your current bash configs to the
following files:

-   the **app/** folder - rename the folder and create an empty one,
    with a subfolder for each app's settings (such as git or mysql)

-   the following general (not app-specific) settings files:

```
                              # type                    when loaded
bash                          # ----                    -----------
├── bash.bash                 # general bash settings   always
├── cmds.bash                 # functions and aliases   always
├── env.bash                  # environment variables   once per login
├── interactive.bash          # interactive settings    all interactive sessions
└── interactive-login.bash    # interactive one-time    once per login, if interactive
```

In addition, there is a directory for settings specific to each
application package you configure:

```
bash
└── apps/                 # settings for specific packages, directory per package
     ├── chruby/           # an example app
     │   ├── cmds.bash     # my app-specific custom functions/aliases
     │   ├── deps          # an optional list of other apps to configure first
     │   ├── detect.bash   # optional app detection expression
     │   ├── env.bash      # app-specific environment vars
     │   └── init.bash     # to source the app-provided initialization, if any (e.g. a script or eval command)
     └── .../              # etc.
```

The files are named with the .bash extension to hint text editor syntax
highlighting, but they can be named whatever you want if you modify
init.bash.

Normally, an app will be detected by the existence of a command of the
same name as the directory under apps/ (e.g. git).

If that is not sufficient, for example if an app can only be detected by
the existence of a file or directory on the filesystem, then you can
write an expression to detect it in **detect.bash** and that will be
used instead, automatically.

Main Code Tree
--------------

Aside from the settings files listed above, the following is the
structure of the project:

```
bash
├── init.bash   # the primary script
├── apps.bash   # code for loading app settings, with detection
└── lib/
     └── initutil.bash     # utility library
```

Assertions and Validation Code
------------------------------

Settings assertions are kept in their own subdirectory along with the
validation code. App validations have their own files in the
**validate/apps/** folder:

```
bash
└── validate/   # all validation-related code and assertions
    ├── validate.bash     # code to run validations
    ├── bash.bash         # assertions for the corresponding settings file
    ├── cmds.bash         # ditto
    ├── env.bash          # ditto
    ├── interactive.bash  # ditto
    ├── interactive-login.bash # ditto
    ├── apps.bash         # code to run app validations
    ├── apps/
    │   ├── chruby.bash   # assertions for app settings
    │   └── ...
    └── lib/
         └── truth.bash    # assertion library
```

Validation is optional and can be disabled in init.bash.

Validation is done with the help of my own **truth.bash** assertion
library, inspired by Google's [Truth] framework for Java.

  [Truth]: https://truth.dev/
