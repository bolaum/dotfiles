#!/bin/bash

APT_BASE_PKGS="vim tmux build-essential curl wget git subversion samba"
PYTHON_BUILD_PKGS="libncursesw5-dev libreadline-dev libssl-dev libgdbm-dev libc6-dev libsqlite3-dev tk-dev libbz2-dev"
# packages to be instaled
ALL_PKGS="$APT_BASE_PKGS $PYTHON_BUILD_PKGS"

# config files to copy
CONFIG_FILES=".bashrc .gitconfig .tmux.conf.local .vimrc"

# default dirs
DEFAULT_DIRS="tmp projs github downloads"

# python versions to be installed
PYTHON_VERSIONS="2.7.13 3.6.2"

# ruby versions to install
RUBY_VERSIONS="2.4.1"

# clone bash_colors
echo "Clonning .bash_colors..."
git clone https://github.com/mercurio21/bash_colors.git $HOME/.bash_colors
source $HOME/.bash_colors/bash_colors.sh

# update and install base packages
clr_bold clr_cyan "Installing base packages..."
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y $ALL_PKGS

# clone bash-it
clr_bold clr_cyan "Clonning bash-it..."
git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it

# clone .tmux
clr_bold clr_cyan "Clonning .tmux..."
git clone https://github.com/gpakosz/.tmux.git $HOME/.tmux
ln -s -f $HOME/.tmux/.tmux.conf $HOME/.tmux.conf

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

# install bash-it
$HOME/.bash_it/install.sh -s
clr_bold clr_cyan "Sourcing .bashrc..."
source $HOME/.bashrc

# copy config files
cp -a bash-it-themes $HOME/.bash-it-themes
ln -s $HOME/.bash-it-themes $HOME/.bash_it/custom/themes
cp -a bin/ $HOME
cp -a $CONFIG_FILES $HOME

# enable bash-it plugins
clr_bold clr_cyan "Enabling bash-it plugins..."
bash-it enable plugin base alias-completion tmux git subversion pyenv node rvm ruby rails

# create default dirs
clr_bold clr_cyan "Creating default dirs..."
cd $HOME
echo $DEFAULT_DIRS | xargs -n 1 mkdir -p || exit
cd -

# install python, set first version as default and install basic packages
clr_bold clr_cyan "Installing python..."
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
echo $PYTHON_VERSIONS | xargs -n 1 pyenv install -k || exit
pyenv global $(echo $PYTHON_VERSIONS | awk '{print $1;}')
pip install ipython

# install ruby and set first version as default
clr_bold clr_cyan "Installing ruby..."
source $HOME/.rvm/scripts/rvm
echo $RUBY_VERSIONS | xargs -n 1 rvm install || exit
rvm --default use $(echo $RUBY_VERSIONS | awk '{print $1;}')

# download fonts
clr_bold clr_cyan "Downloading fonts..."
wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Windows%20Compatible.otf?raw=true -O $HOME/tmp/FuraCodeNFRegularWindows.otf

wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/FiraCode/Regular/complete/Fura%20Code%20Regular%20Nerd%20Font%20Complete%20Mono.otf?raw=true -O $HOME/tmp/FuraCodeNFRegularMono.otf

# show a list of manual steps
END_MESSAGE="
Instalation done!
Please do the following manually:
\t- Install nerd fonts in tmp/ to terminal emulator
\t- Add ssh key to github

For VMs:
\t- Set samba password
\t\t$ smbpasswd
\t- Add the following to '/etc/samba/smb.conf' to share home via samba

[vmhome]
\tpath = $HOME
\tvalid users = $USER
\tread only = no
\tcreate mask = 664
\tdirectory mask = 2755
\tmap archive = no

\t- restart samba:
\t\t$ sudo service smbd restart

These will test for high color support in terminal:
"
while read -r line; do
  clr_escape "$line" $CLR_BOLD $CLR_CYAN
done <<< "$END_MESSAGE"

export PATH="$HOME/bin:$PATH"
24-bit-color.sh
echo
testtruecolor.sh

