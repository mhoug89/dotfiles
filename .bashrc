# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# For letting me know when a file doesn't exist, etc.
PRINT_WARNINGS=0

############################################################################
# FUNCTIONS ################################################################
#
# These functions are defined here, rather than in the file specifically for
# functions, because they are used by other setup steps/scripts and need to be
# declared before those run.

# Args to this function should each be an ABSOLUTE path to the desired dir.
# Taken from https://superuser.com/a/753948
path_append() {
  for ARG in "$@"
  do
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="${PATH:+"$PATH:"}$ARG"
    fi
  done
}

# Args to this function should each be an ABSOLUTE path to the desired dir. For
# convenience, args are prepended in reverse order, e.g. `path_prepend P1 P2 P3`
# would result in a PATH of "P1:P2:P3:${PATH}".
# Taken from https://superuser.com/a/753948
path_prepend() {
  for ((i=$#; i>0; i--));
  do
    ARG=${!i}
    if [ -d "$ARG" ] && [[ ":$PATH:" != *":$ARG:"* ]]; then
        PATH="$ARG${PATH:+":$PATH"}"
    fi
  done
}

source_file_if_exists() {
  if [ -f "$1" ]; then
    source "$1"
  fi
}

# END FUNCTIONS ############################################################
############################################################################

# If not running interactively, don't do anything.
[ -z "$PS1" ] && return

# Make vim the default editor!
export EDITOR=vim

# unsetting hist{file}size means unlimited history.
export HISTSIZE=
export HISTFILESIZE=
export HISTCONTROL=ignorespace  # Ignore just whitespace.
#export HISTCONTROL=ignoredups  # Ignore duplicate entries.
# Append to the history file, don't overwrite it.
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Allow bash to expand paths from variables for tab completion, e.g.
# `vim $HOME/some_dir/<TAB>` -> `vim /home/UserBob/some_dir/`.
shopt -s direxpand

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ] ; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
  xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    color_prompt=yes
  else
    color_prompt=
  fi
fi

#if [ "$color_prompt" = yes ]; then

# \e is ASCII escape character (same as \033).
# \[ and \] begin/end a sequence of non-printed characters.
# 1 is bold, 40 is light-black background
C_RED_BOLD='\[\e[1;31;40m\]'
C_GREEN_BOLD='\[\e[1;32;40m\]'
C_YELLOW_BOLD='\[\e[1;33;40m\]'
C_LIGHT_BLUE_BOLD='\[\e[1;36;40m\]'
C_WHITE='\[\e[37;40m\]'
C_WHITE_BOLD='\[\e[1;37;40m\]'
C_END='\[\e[0m\]'
PS1="${C_WHITE}\! ${C_RED_BOLD}\u${C_WHITE_BOLD}@${C_GREEN_BOLD}\h "
PS1+="${C_YELLOW_BOLD}\W${C_LIGHT_BLUE_BOLD} "
PS1+="\$(parse_and_truncate_git_branch)\$${C_END} "
# Prepend newline to PS1 var. For commands that output content that
# does not have a trailing newline, we'd usually see our prompt get
# tacked on to the end of the output. To avoid this, we always add
# an extra newline before printing our prompt.
PS1="\n$PS1"

#else
#    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
#fi
#unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
  xtermpetdp121|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
  petdp121)
    ;;
esac

# Add various local bin directories to PATH.
# Counter-based for loop (this method accounts for spaces in file names).
_add_dirs_to_path() {
  dirs_to_add_to_path=(
    "$HOME/bin"
    # Some tools install things here, e.g. `pip install --user <package>`.
    "$HOME/.local/bin"
  )
  arr_len=${#dirs_to_add_to_path[@]}
  local i
  for (( i=0; i<${arr_len}; i++ )); do
    path_append "${dirs_to_add_to_path[$i]}"
  done
}
_add_dirs_to_path
unset -f _add_dirs_to_path

# We do this in a function in order to not use global counter variables. As an
# example: if both your .bashrc and .bashrc_local were to use this same block of
# code without being nested in a function, and your counter variable were
# global, the source'd script would share the same counter variable, leading to
# possibilities like skipping files that should be sourced, or even worse,
# hitting an infinite loop that might cause your shell to never load.
_source_rc_files() {
  # Create an array of files/dirs that should be sourced. If they don't exist,
  # they'll be skipped.
  #
  # You can also add directories such that every file in the directory is
  # sourced. Note that this does not work recursively; only one directory level
  # is walked.
  local files_to_source=(
    "/etc/bash_completion"
    "${HOME}/.bashrc.d"
    "${HOME}/.bashrc_local"
    "${HOME}/.bashrc_work"
  )
  local arr_len=${#files_to_source[@]}

  local i
  for (( i=0; i<${arr_len}; i++ )); do
    if [ -f "${files_to_source[$i]}" ]; then
      source "${files_to_source[$i]}"
    elif [ -d "${files_to_source[$i]}" ]; then
      shopt -s dotglob  # Make glob return hidden files too
      for script in "${files_to_source[$i]}"/* ; do
        source_file_if_exists "$script"
      done
      shopt -u dotglob
    elif (( $PRINT_WARNINGS )); then
      # Alert me when a file doesn't exist.
      # BASH_SOURCE shows this script's filename.
      echo "${BASH_SOURCE}: Supposed to source ${files_to_source[$i]}, file didn't exist."
    fi
  done
}
_source_rc_files
unset -f _source_rc_files
