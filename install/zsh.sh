#!/bin/bash

sudo apt install zsh -y


# Make ZSH default shell
chsh -s $(which zsh)

# Reboot now - Easiest way to confirm
sudo reboot now
