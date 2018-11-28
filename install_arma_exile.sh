#!/bin/bash
# VARS SETUP
NC='\033[0m'  # no color
CYAN='\033[0;36m'  # cyan
RED='\033[0;31m'  #red 
INSTALL_PATH=$"/arma"

: <<'COMMENT'
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
dpkg --add-architecture i386; sudo apt update; sudo apt install mailutils postfix curl wget file bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux lib32gcc1 libstdc++6 libstdc++6:i386  # holy dependencies for LGSM
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
COMMENT

echo -e "${CYAN}Downloading and extracting Exile and ExileServer mod.${NC}"
sleep 2
if [ ! `ls "@ExileServer-1.0.4.zip" > /dev/null 2>&1` ] || [ ! `ls "ExileServer-1.0.4a.zip" > /dev/null 2>&1` ];
then
	wget "http://85.25.202.58/download-all-the-files/ExileServer-1.0.4a.zip"
	wget "http://palmbeachpc.com/@Exile-1.0.4.zip"
	wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh ${USER}
fi


# unzip and cleanup of archive
if [ ! `ls -l @Exile/ > /dev/null 2>&1` ] || [ ! `ls -l "Arma 3 Server" > /dev/null 2>&1` ];
then
	unzip "@Exile-1.0.4.zip"
	rm "@Exile-1.0.4.zip"
	unzip "ExileServer-1.0.4a.zip"
	rm "ExileServer-1.0.4a.zip"
fi


# create dir and chown it to arma3server
if [ ! -d "/arma" ];
then 
	mkdir /arma
	chown $USER:$USER "/arma"
	cd /arma
else
	cd /arma
fi


