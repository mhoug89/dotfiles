# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# For letting me know when a file doesn't exist, etc.
PRINT_WARNINGS=0

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export HISTCONTROL=ignorespace  # Ignore just whitespace.
#export HISTCONTROL=ignoredups  # Ignore duplicate entries.

# make vim the default editor
export EDITOR=vim

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
export HISTSIZE=200000
export HISTFILESIZE=200000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

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

PS1='\[\e[1;31;40m\]\u\[\e[1;37;40m\]@\[\e[1;32;40m\]\h \[\e[1;33;40m\]\W\[\e[1;36;40m\] $\[\e[0m\] '
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

if [ -d "$HOME/bin" ]; then
  PATH="$PATH:$HOME/bin"
fi

# Create an array of files that should be sourced.
# Can also add directories such that every file in the directory is sourced.
Files2Source=(
  "/etc/bash_completion"
  "$HOME/rc.d"
  # Should source all files in rc.work.d, as well as other necessary stuff.
  "${HOME}/.bashrc_work"
)

# Counter-based for loop (this method accounts for spaces in file names)
sourceLen=${#Files2Source[@]}
for (( i=0; i<${sourceLen}; i++ )); do
  if [ -f ${Files2Source[$i]} ]; then
    . ${Files2Source[$i]}
  elif [ -d ${Files2Source[$i]} ]; then
    shopt -s dotglob
    for script in "${Files2Source[$i]}"/* ; do
      . "$script"
    done
    shopt -u dotglob
  elif (( $PRINT_WARNINGS )); then
    # Alert me when a file doesn't exist.
    # BASH_SOURCE shows this script's filename.
    echo "${BASH_SOURCE}: Supposed to source ${Files2Source[$i]}, file didn't exist."
  fi
done
