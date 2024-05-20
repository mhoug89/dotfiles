# Commands:
#
# Install a specific Python version, e.g. 2.7.8:
# $ pyenv install 2.7.8
#
# Update to newest dev version of pyenv:
# $ cd $(pyenv root)
# $ git pull

# NOTE: Commented this out due to issues with using pyenv by default for running
# existing Python applications. For the time being, I run things that require
# pyenv in a subshell so that I don't mess with my parent shell, e.g.:
#
# ```
# (
#   export PYENV_ROOT="$HOME/.pyenv"
#   [[ -d $PYENV_ROOT/bin ]] \
#     && export PATH="$PYENV_ROOT/bin:$PATH" \
#     && eval "$(pyenv init -)" \
#     && pyenv activate 3.8.19/envs/venv-3.8.19 \
#     && python -m COMMAND_HERE \
#     && pyenv deactivate
# )
# ```
#
#
# if [ -d "${HOME}/.pyenv" ]; then
#   export PYENV_ROOT="${HOME}/.pyenv"
#   path_prepend "${PYENV_ROOT}/bin"
# fi
#
# if command -v pyenv 1>/dev/null 2>&1; then
#   eval "$(pyenv init -)"
# fi
