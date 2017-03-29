if [ -f "${HOME}/.bashrc" ]; then
  # MacOS/OSX stuff for ansi colors in iTerm2:
  if [ -n "$OSTYPE" ] && [[ "$OSTYPE" =~ "darwin" ]]; then
    export CLICOLOR=1
    export TERM=xterm-256color
    export LSCOLORS=ExFxBxDxCxegedabagacad
  fi

  # Everything else:
  source "${HOME}/.bashrc"
fi
