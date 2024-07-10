#!/bin/bash

# Makes directories for OPENVPN config
mkdir -p ~/.ovpnconfig

# Adds Custom items to end of ~/.bashrc
cat ~/.bashrc ./files/htb.txt > /tmp/.bashrc_modified
mv /tmp/.bashrc_modified ~/.bashrc 