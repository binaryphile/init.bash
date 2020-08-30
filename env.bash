# env.bash - general (not app-specific) environment variables

# ========
# Examples
# ========

# # add user directory to beginning of PATH
# # I don't bother re-exporting variables I know are already exported
# PATH=$HOME/.local/bin:$PATH

# # explicitly set my editor based on whether nvim is available
# TestCmdAndExport EDITOR vim
# TestCmdAndExport EDITOR nvim
# TestCmdAndExport PAGER less

# # set explicitly so I can use the same variable across systems that don't
# # have XDG* variables preset
# TestAndExport XDG_CONFIG_HOME $HOME/.config
