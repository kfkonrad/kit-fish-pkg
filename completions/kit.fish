# Always provide completions for command line utilities.
#
# Check Fish documentation about completions:
# http://fishshell.com/docs/current/commands.html#complete
#
# If your package doesn't provide any command line utility,
# feel free to remove completions directory from the project.

set -l subcommands clone help version
set -l message_clone "works like git clone, but chooses the directory to clone into based on the URL"
set -l message_help "prints version"
set -l message_version "prints help message"

complete -f -n "__fish_use_subcommand $subcommands" -c kit -a clone -d $message_clone
complete -f -n "__fish_use_subcommand $subcommands" -c kit -a help -d $message_version
complete -f -n "__fish_use_subcommand $subcommands" -c kit -a version -d $message_help

complete -f -c kit -s v -d $message_version
complete -f -c kit -s h -d $message_help

complete -f -c kit -l version -d $message_version
complete -f -c kit -l help -d $message_help
