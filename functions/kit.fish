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

  if functions -q __kit_$command
      eval __kit_$command $argv
  else
      git $command $argv
  end

end

function __kit_version
 echo v0.2.0
end

function __kit_help
  echo "kit - Kevin's git wrapper"
  echo
  echo 'subcommands:'
  echo '  clone'
  echo '    clone into automatically chosen directory'
  echo '  version'
  echo '    prints version of kit'
  echo '  help'
  echo '    prints this help'
  echo '  *'
  echo '    pass to git'
end

function __kit_clone
  set url (__kit_helper_get_first_non_option_argument $argv)
  set fullpath (__kit_helper_extract_full_path $url)
  mkdir -p $fullpath
  git clone $argv $fullpath
end

function __kit_push
  set branch (git branch --show-current)
  set git_remote (git remote)
  if test (count $git_remote) = 1
    set remote $git_remote
  else if set -q kit_default_remote
    set remote $kit_default_remote
  else
    set remote origin
  end
  git push $argv -u $remote $branch
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
  set schemaless (echo $argv[1] | sed 's/.*@//;s|:|/|;s|\.git$||')
  __kit_helper_extract_full_path_generic $schemaless
end

function __kit_helper_extract_full_path_https
  set schemaless (echo $argv[1] | sed 's|^https://||;s|\.git$||')
  __kit_helper_extract_full_path_generic $schemaless
end

function __kit_helper_extract_full_path_generic
  set fqdn (echo $argv[1] | sed 's|/.*||')
  set fish_friendly_fqdn (echo $fqdn | sed 's/\./_/g')
  if set -q kit_domain_filter_$fish_friendly_fqdn
    set domain_filter (eval echo \$kit_domain_filter'_'$fish_friendly_fqdn)
  else if set -q kit_domain_filter
    set domain_filter $kit_domain_filter
  else
    set domain_filter 's|\..*$||'
  end
  set domain_path (echo $fqdn | sed "$domain_filter")
  set rest_path (echo $argv[1] | sed 's|[^/]*/||')
  if set -q kit_base_dir
    set -l kit_base_dir $HOME/workspace
    echo $kit_base_dir/$domain_path/$rest_path
  end
end
