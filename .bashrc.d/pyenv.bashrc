# Commands:
#
# Install a specific Python version, e.g. 2.7.8:
# $ pyenv install 2.7.8
#
# Update to newest dev version of pyenv:
# $ cd $(pyenv root)
# $ git pull

if [ -d "${HOME}/.pyenv" ]; then
  export PYENV_ROOT="${HOME}/.pyenv"
  path_prepend "${PYENV_ROOT}/bin"
fi

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
