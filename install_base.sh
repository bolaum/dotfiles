#!/bin/bash

APT_BASE_PKGS="awk vim tmux build-essential curl wget git subversion"
PYTHON_BUILD_PKGS="libncursesw5-dev libreadline-dev libssl-dev libgdbm-dev libc6-dev libsqlite3-dev tk-dev libbz2-dev"
# packages to be instaled
ALL_PKGS="$APT_BASE_PKGS $PYTHON_BUILD_PKGS"

# python versions to be installed
PYTHON_VERSIONS="2.7.13 3.6.2"

# ruby versions to install
RUBY_VERSIONS="2.4.1"

# exit on error
set -e

# update and install base packages
clr_bold clr_cyan "Installing base packages..."
sudo apt-get update
sudo apt-get install $ALL_PKGS

# clone bash-it
clr_bold clr_cyan "Clonning bash-it..."
git clone https://github.com/Bash-it/bash-it.git .bash_it
ln -s bash-it-themes/ .bash_it/custom/themes

# clone .tmux
clr_bold clr_cyan "Clonning .tmux..."
git clone https://github.com/gpakosz/.tmux.git .tmux
ln -s -f .tmux/.tmux.conf

# clone bash_colors
clr_bold clr_cyan "Clonning .bash_colors..."
git clone https://github.com/mercurio21/bash_colors.git .bash_colors

# install pyenv
clr_bold clr_cyan "Installing pyenv..."
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash

# install node
clr_bold clr_cyan "Installing node..."
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs

# install rvm
clr_bold clr_cyan "Installing rvm..."
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
\curl -sSL https://get.rvm.io | bash -s stable

# get bash configs running
clr_bold clr_cyan "Sourcing .bashrc..."
source .bashrc

# enable bash-it plugins
clr_bold clr_cyan "Enabling bash-it plugins..."
bash-it enable plugin base alias-completion tmux git subversion pyenv node rvm ruby rails

# create default dirs
clr_bold clr_cyan "Creating default dirs..."
mkdir -p tmp projs downloads

# install python, set first version as default and install basic packages
clr_bold clr_cyan "Installing python..."
echo $PYTHON_VERSIONS | xargs -n 1 pyenv install -kv
pyenv global $(echo $PYTHON_VERSIONS | awk '{print $1;}')
pip install ipython

# install ruby and set first version as default
clr_bold clr_cyan "Installing ruby..."
echo $RUBY_VERSIONS | xargs -n 1 rvm install
rvm --default use $(echo $RUBY_VERSIONS | awk '{print $1;}')

# download fonts
wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.otf?raw=true -O tmp/FuraCodeNFRegularWindows.otf

wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.otf?raw=true -O tmp/FuraCodeNFRegularMono.otf

# show a list of manual steps
END_MESSAGE="
Instalation done!
Please do the following manually:
  - Install nerd fonts in tmp/ to terminal emulator
  - Add ssh key to github

These will test for high color support in terminal:
"
clr_bold clr_cyan $END_MESSAGE
24-bit-color.sh
echo
testtruecolor.sh

