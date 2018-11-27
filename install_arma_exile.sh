#!/bin/bash
# VARS SETUP
NC='\033[0m'  # no color
CYAN='\033[0;36m'  # cyan
RED='\033[0;31m'  #red 
INSTALL_PATH=$"/arma"

# create user for server
USER="arma3server"
echo -e "${CYAN}Creating a user for the server to run under #security${NC}"
sleep 1
echo -e "${CYAN}Enter a password for the new user:${NC}"
read USER_PASSWORD
# check if user already exists. if not, create it
if [ `id -u $USER 2>/dev/null || echo -1` -ge 0 ]; then
	echo -e "${CYAN}$USER already present... proceeding."
else
	if [ ! -d "/home/$USER" ]; 
	then
		useradd -m -p $USER_PASSWORD -s /bin/bash arma3server
	else 
		useradd -p $USER_PASSWORD -s /bin/bash arma3server
	fi
fi

sleep 2

# install armake and dependencies
echo -e "${CYAN}Checking for Armake dependencies...${NC}"
sleep 2
apt-get install gcc libssl-dev -y
add-apt-repository ppa:koffeinflummi/armake
apt-get update
apt-get install armake

# download mod to /tmp/exile/
if [ ! -d "/tmp/exile" ];
then
	mkdir /tmp/exile
	chown $USER:$USER /tmp/exile
	cd /tmp/exile
else
	cd /tmp/exile/
fi

# check if mod/lgsm is downloaded. if not, download them.

echo -e "${CYAN}Downloading and extracting Exile and ExileServer mod.{$NC}"
sleep 2
if [ ! `ls @ExileServer-1.0.4.zip > /dev/null 2>&1` || ! `ls ExileServer-1.0.4a.zip > /dev/null 2>&1` ];
then
	wget "http://85.25.202.58/download-all-the-files/ExileServer-1.0.4a.zip"
	wget "http://palmbeachpc.com/@Exile-1.0.4.zip"
fi

unzip "@Exile-1.0.4.zip"
unzip "ExileServer-1.0.4a.zip"

# create dir and chown it to arma3server
if [ ! -d "/arma" ];
then 
	mkdir /arma
	chown $USER:$USER "/arma"
else
	cd /arma
fi
