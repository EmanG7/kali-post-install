#!/bin/bash

# Makes directories to deploy tools from
mkdir -p ~/tools

# List of tools in order
# nc.exe
# pspy
# winpeas.exe
# linpeas.sh

wget https://github.com/int0x33/nc.exe/raw/master/nc.exe ~/tools/nc.exe
wget https://github.com/int0x33/nc.exe/raw/master/nc64.exe ~/tools/nc64.exe

# Adds Custom items to ~/.bashrc
cat ~/.bashrc ./files/tools.txt > /tmp/.bashrc_modified
mv /tmp/.bashrc_modified ~/.bashrc 