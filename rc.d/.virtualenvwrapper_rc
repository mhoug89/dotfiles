# If python virtualenvwrapper is installed, make sure we perform all its
# necessary setup steps. This allows easily working with python virtualenvs:
# $ mkvirtualenv my_env
# $ workon my_env
# $ deactivate
# $ rmvirtualenv my_env
venv_wrapper_sh=""
# Look for system-wide installation first (usually via `sudo pip install ...`
if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
  venv_wrapper_sh="/usr/local/bin/virtualenvwrapper.sh"
# May have also been installed locally, via `pip install --user ...`
elif [ -f "${HOME}/.local/bin/virtualenvwrapper.sh" ]; then
  venv_wrapper_sh="${HOME}/.local/bin/virtualenvwrapper.sh"
fi
if [ -n "$venv_wrapper_sh" ]; then
  export WORKON_HOME="${HOME}/.virtualenvs"
  if [ ! -d "${HOME}/venv_projects" ]; then
    mkdir "${HOME}/venv_projects"
  fi
  export PROJECT_HOME="${HOME}/venv_projects"
  source "${venv_wrapper_sh}"
fi
