#!/bin/bash
# setup.sh - Matt Houglum (2014)
#
# This moves all .rc and other configuration files to their appropriate
# places within the user's $HOME directory. This aids in easy customization
# and setup.

# Files in this repo that aren't config files.
DO_NOT_COPY=(".git" "setup.sh" "README.md" "diff_with_current.sh")
# Get the location (parent folder) of this script - not the location it was
# run from!
SETUP_DIR="$(dirname "$0")"
SETUP_DIR="$( (cd "$SETUP_DIR" && pwd) )"

# Make sure the user wants to potentially replace any existing files.
read -p $'This script will replace your existing configuration files.\nAre you sure you want to continue? [Y/n]: ' -r RESP
if ! [[ $RESP =~ ^$|^[Yy] ]] ; then
  echo "Setup cancelled."
  exit
fi

echo
echo " * Copying configuration files..."

shopt -s dotglob  # Make sure globbing includes hidden files.
for item in "$SETUP_DIR"/*; do
  # Copy everything all files except the exceptions to your home dir.
  itemshort=$(basename "$item")
  found=0
  for entry in "${DO_NOT_COPY[@]}"; do
    if [[ "$entry" == "$itemshort" ]]; then
      found=1
    fi
  done
  if (( !found )); then
    cp -r "$item" "$HOME"
  fi
done
shopt -u dotglob

# Running in subshell -- cannot apply to parent shell.
#echo " * Sourcing .profile... "
#source "$HOME/.profile"

echo
echo " * Cloning (or replacing) git dependencies..."

rm -rf ~/.vim/bundle/Vundle.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

rm -rf ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Make sure git submodules have been initialized and updated. Do this in a
# subshell to avoid altering our working directory via the `cd` command.
( cd $SETUP_DIR; git submodule update --init --recursive )

echo
echo "* Running vim commands to install plugins and their dependencies..."
sudo apt install build-essential clang cmake vim-nox python3-dev mono-complete golang nodejs default-jdk npm python-is-python3
vim +PluginInstall +GoInstallBinaries +qall
( cd ~/.vim/bundle/youcompleteme && python3 install.py --all )

echo "* Setup complete!"
