#!/bin/bash

APT_PACKAGES="vim tmux python-pip ipython"

sudo apt-get update
sudo aptget install $APT_PACKAGES

git clone https://github.com/Bash-it/bash-it.git .bash_it
git clone https://github.com/gpakosz/.tmux.git .tmux
