cat_md() {
  command -v pandoc >/dev/null 2>&1 || { echo "pandoc not in PATH" >&2; return; }
  command -v lynx >/dev/null 2>&1 || { echo "lynx not in PATH" >&2; return; }
  pandoc $1 | lynx -stdin
}

### CHFs (Common Helper Functions):
# Most of these were taken from:
# https://github.com/martinburger/bash-common-helpers

# Returns numeric values to be used within conditional checks, e.g.:
#   $ if cmn_check_dir_exists /some/dir; then do_stuff(); fi
#   $ if ! cmn_check_dir_exists /some/garbage/path; then do_stuff(); fi
chf__check_dir_exists() {
  local fpath="${1}"
  [[ -d "${fpath}" ]]
  return $?
}

# Returns numeric values to be used within conditional checks, e.g.:
#   $ if cmn_check_file_exists /some/file; then do_stuff(); fi
#   $ if ! cmn_check_file_exists /some/garbage/path; then do_stuff(); fi
chf__check_file_exists() {
  local fpath="${1}"
  [[ -f "${fpath}" ]]
  return $?
}

chf__echo_green() {
  local green=$(tput setaf 2)
  local reset=$(tput sgr0)
  echo -e "${green}$@${reset}"
}

chf__echo_red() {
  local red=$(tput setaf 1)
  local reset=$(tput sgr0)
  echo -e "${red}$@${reset}"
}

chf__echo_yellow() {
  local yellow=$(tput setaf 3)
  local reset=$(tput sgr0)
  echo -e "${yellow}$@${reset}"
}

# Replaces given string 'placeholder' with 'replace' in given files.
#
# Important: The replacement is done in-place. Thus, it overwrites the given
# files, and no backup files are created.
#
# Note that this function is intended to be used to replace fixed strings; i.e.,
# it does not interpret regular expressions. It was written to replace simple
# placeholders in sample configuration files (you could say very poor man's
# templating engine).
#
# This functions expects given string 'search' to be found in all the files;
# thus, it expects to replace that string in all files. If a given file misses
# that string, a warning is issued by calling `cmn_echo_warn`. Furthermore,
# if a given file does not exist, a warning is issued as well.
#
# To replace the string, perl is used. Pattern metacharacters are quoted
# (disabled). The search is a global one; thus, all matches are replaced, and
# not just the first one.
#
# Example:
#   $ chf__replace_in_files placeholder replacement file1.txt file2.txt
chf__replace_in_files() {
  # Don't allow search placeholder to be empty or unset
  local search="${1:?}"
  # Allow replacement to be empty, but not unset
  local replace="${2:+}"
  local files=${@:3}

  for curfile in ${files[@]}; do
    if [[ -e "${curfile}" ]]; then
      if ( grep --fixed-strings --quiet "${search}" "${curfile}" ); then
        perl -pi -e "s/\Q${search}/${replace}/g" "${curfile}"
      else
        chf__echo_yellow "Could not find search string '${search}' (thus," \
                        "cannot replace with '${replace}') in file: ${curfile}"
      fi
    else
        chf__echo_yellow "File '${curfile}' does not exist (thus, cannot" \
                        "replace '${search}' with '${replace}')."
    fi
  done
}

# Prints info about available clusters, plus namespaces in current cluster.
mlh__kube_grok() {
  DIVIDER="---------------------------------"
  echo "${DIVIDER}"
  echo ">>> Info about all clusters:"

  ( set -x; kind get clusters )
  echo

  ( set -x; kubectl config get-clusters )
  echo

  ( set -x; kubectl config get-contexts )
  echo

  ( set -x; kubectl config get-users )
  echo

  echo "${DIVIDER}"
  echo ">>> Info about current cluster (as determined by current context):"
  echo

  ( set -x; kubectl get namespaces )
  echo

  ( set -x; kubectl --namespace default get all )
  echo
}

# Prints all resources (as detected by "all") under each namespace in current
# cluster.
mlh__kube_get_resources() {
  DIVIDER="---------------------------------"
  for kube_ns in $(kubectl get namespaces --no-headers -o custom-columns=":metadata.name"); do
    echo "${DIVIDER}"
    ( set -x; kubectl --namespace "${kube_ns:?}" get all )
    echo
  done
}

# For use with PS1 variable, echoes "(my-branch) "
parse_and_truncate_git_branch() {
  # Note: We could use the __git_ps1 function (if available) if we wanted the
  # full branch name displayed.
  local branch_str="$(git branch --show-current 2> /dev/null)"
  if [[ -z "$branch_str" ]]; then
    return
  fi
  # Truncate and add ellipses if the string is too long.
  if (( ${#branch_str} >= 16 )); then
    branch_str="${branch_str:0:13}..."
  fi
  # Echo with a trailing space.
  echo "($branch_str) "
}

# Parse seconds, milliseconds, and microseconds timestamps into readable dates.
parse_xsec() {
  local base=${1:?}
  shift

  while [ $# -gt 0 ]
  do
    secs=$(echo "scale=6; ${1}/${base}" | bc)
    date -d @$secs +"%F %T.%N %z"
    shift
  done
}

parse_msec() {
  parse_xsec 1000 "${1:?}"
}

parse_sec() {
  parse_xsec 1 "${1:?}"
}

parse_usec() {
  parse_xsec 1000000 "${1:?}"
}

rdp_with_flags() {
  if [[ "$#" != 2 ]] ; then
    echo "Please supply two arguments: host [domain\\\\]user"
    return 0
  fi
  monitor_1_dimen=$(xrandr | head -n 5 | \grep -o -P \
                    "primary \d{3,4}x\d{3,4}" | cut -d' ' -f2)

  if [ -z $monitor_1_dimen ]; then
    monitor_1_dimen="800x600"
  else
    # To show the top of the guest screen while also keeping the host box's
    # window toolbar in view, I just estimate that the host toolbar takes
    # up a bit less than 5% of the screen, making rdesktop use 95% height.
    width=$(echo $monitor_1_dimen | cut -dx -f1 )
    # width=$(echo "$width * .95" | bc -q | awk '{printf("%d\n",$1 + 0.5)}')
    height=$(echo $monitor_1_dimen | cut -dx -f2)
    height=$(echo "$height * .95" | bc -q | awk '{printf("%d\n",$1 + 0.5)}')
    monitor_1_dimen=${width}x${height}
  fi
  echo "Using window dimensions: $monitor_1_dimen"
  rdesktop $1 -z -g $monitor_1_dimen -P -D -a 32 -u $2
}

update-repo() {
  for source in "$@"; do
    sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/${source}" \
    -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"
  done
}
