#!/bin/bash

# Run with a sudo/su root wrapper 
# > chmod a+x ./*
# > su -c ./post-install.sh root

clear
# Defined colour settings
RED=$(tput setaf 1 && tput bold)
GREEN=$(tput setaf 2 && tput bold)
BLUE=$(tput setaf 6 && tput bold)
STAND=$(tput sgr0)
echo ""
echo $BLUE"### Running Kali Post-Install Script ###"$STAND
echo ""
sleep 1

tools="YES"
htb="no"

# Default or Advanced Settings?
read -p "Advanced Settings: [Y/n] > " adv_set
clear
if [[ $adv_set =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo $RED"Advanced Settings: ON"$STAND
else
    echo $BLUE"Default Settings: ON"$STAND
fi
echo ""
if [[ $adv_set =~ ^([yY][eE][sS]|[yY])$ ]]; then
    read -p "Enable ~/tools feature [Y/n] > " tools
    read -p "Enable HTB feature [Y/n] > " htb
fi
sleep 1
clear

# Questionnaire about potential users
read -p "What is default user's name > " default_user
user_list=($default_user)
read -p "Add a sudo user: [Y/n] > " sudo 
if [[ $sudo =~ ^([yY][eE][sS]|[yY])$ ]] ; then
    while : ; do
        read -p "What is sudo user's name > " sudo_user
        user_list+=($sudo_user)
        adduser --disabled-password --gecos "" $sudo_user 1> /dev/null
        usermod -aG sudo $sudo_user
        read -p "Add another sudo user: [Y/n] > " sudo
        [[ $sudo =~ ^([yY][eE][sS]|[yY])$ ]] || break
    done
fi
for user in ${user_list[@]}; do
    read -s -p "Insert $user password > " password
    echo -e "$password\n$password" | passwd $user 1> /dev/null
done
echo ""
echo $GREEN"### Users Updated & Saved ###"$STAND
sleep 1
clear

# New Installation, Updates, and Upgrades
echo $RED"### Updating/Upgrading ###"
apt update && apt upgrade -y
echo $GREEN"### Successful Update/Upgrade ###"
sleep 1
clear

echo $RED"### Installing Kali Metapackage: Large ###"
apt install kali-linux-large -y
echo $GREEN"### Successful Install ###"
sleep 1
clear

echo $RED"### Installing Extra Items ###"
apt install libreoffice libreoffice-gtk4 htop -y
echo $GREEN"### Successful Install ###"

echo $STAND"### CLEANING ###"
apt autoremove -y
echo "### CLEANED ###"
sleep 1
clear

sed -i.bak "1i\
alias sudo='sudo '\
" ~/.bashrc

if [[ $tools =~ ^([yY][eE][sS]|[yY])$ ]]; then
    bash ./tools.sh
fi

if [[ $htb =~ ^([yY][eE][sS]|[yY])$ ]]; then
    bash ./htb-addition.sh
fi

# Changing Prompt Alternative from 'twoline' to 'oneline'
sed -i "" ~/.bashrc 

# Copying ~/.zshrc to user_list's users
for user in $user_list; do
    if [[ $user != 'root' ]]; then
        cp ~/.bashrc /home/$user/
    fi
done

echo $RED"### Refreshing Shell ###"
bash
source ~/.bashrc
echo ""
echo $GREEN"### Shell Refreshed ###"$STAND
sleep 1
exit 1