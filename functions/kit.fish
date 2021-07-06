function kit --description "Kevin's custom wrapper around some git commands"
  while set -q argv[1]
    switch $argv[1]
      case '-h' '--help' '-\?' '/\?'
        set command help

      case '-v' '--version'
        set command version

      case '-?*'
        echo "Unknown option: $argv[1]" >&2
        return 1

      case '*'
        break
    end

    set -e argv[1]
  end

  switch "$argv[-1]"
    case '-h' '--help' '-\?' '/\?'
      set command help
      set -e argv[-1]
  end

  if not set -q command
    if set -q argv[1]
      set command $argv[1]
      set -e argv[1]
    else
      set command help
    end
  end

  if test $command = "version"
    __kit_version
  else if test $command = "help"
    __kit_help
  else if test $command = "clone"
    __kit_clone $argv
  else
      echo "Unknown command: $command" >&2
      echo "Try kit --help" >&2
  end

end

function __kit_version
 echo v0.0.1
end

function __kit_help
  echo "kit - Kevin's git wrapper"
  echo
  echo 'subcommands:'
  echo '  clone'
  echo '    works like git clone, but chooses the directory to clone into based on the URL'
  echo '  version'
  echo '    prints version of kit'
  echo '  help'
  echo '    prints this help'
end

function __kit_clone
  set url (__kit_helper_get_first_non_option_argument $argv)
  set fullpath (__kit_helper_extract_full_path $url)
  mkdir -p $fullpath
  git clone $argv $fullpath
end

# this also excludes arguments to options like so
# -f a b       -> b
# -f a         -> a
# --foo a b    -> b
# --foo a      -> a
# a b          -> a
# a            -> a
# -f a -g      -> [empty]
# -f a -g b    -> b
function __kit_helper_get_first_non_option_argument
  while set -q argv[1]
    switch $argv[1]
      case '-?*'
        if set -q argv[3] && grep -qve "^-" (echo -- $argv[2] | psub)
          set -e argv[2]
        end
      case '*'
        echo $argv[1]
        break
    end
    set -e argv[1]
  end
end


function __kit_helper_extract_full_path
  if grep -qe "^git@" (echo $argv[1] | psub)
    __kit_helper_extract_full_path_ssh $argv[1]
  else
    __kit_helper_extract_full_path_https $argv[1]
  end
end

function __kit_helper_extract_full_path_ssh
  set host (echo $argv[1] | sed 's/.*@//;s/:.*//;s/\..*$//')
  set gitpath (echo $argv[1] | sed 's/.*://;s/\.git$//')
  echo $HOME/workspace/$host/$gitpath
end

function __kit_helper_extract_full_path_https
  set schemaless (echo $argv[1] | sed 's|^https://||')
  set host (echo $schemaless | sed 's|/.*||;s|\..*$||')
  set gitpath (echo $schemaless | sed 's|[^/]*/||;s|\.git$||')
  echo $HOME/workspace/$host/$gitpath
end
