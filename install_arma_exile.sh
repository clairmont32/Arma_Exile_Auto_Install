#!/bin/bash
# VARS SETUP
NC='\033[0m'  # no color
CYAN='\033[0;36m'  # cyan
RED='\033[0;31m'  #red 
INSTALL_PATH=$"/arma"

# create user for server
#: <<'COMMENT'
USER="arma3server"
echo -e "${CYAN}Creating a user for the arma server to run under... #security${NC}"
sleep 1
# check if user already exists. if not, create it
if [ `id -u $USER 2>/dev/null || echo -1` -ge 0 ]; then
	echo -e "${CYAN}$USER already present... proceeding."
else
	
	if [ ! `ls "/home/$USER > /dev/nul 2>&1` ]; 
		echo -e "${CYAN}Enter a password for the new user:${NC}"
		read USER_PASSWORD

	then
		useradd -m -p $USER_PASSWORD -s /bin/bash arma3server
	else 
		useradd -p $USER_PASSWORD -s /bin/bash arma3server
	USER_PASSWORD=""  # #security
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

# switch to arma3server user for the rest of manipulation
cd /home/arma3server

# download mod to /tmp/exile/
if [ ! `ls tmp/exile > /dev/null 2>&1` ];
then
	mkdir tmp/exile
	chown arma3server:arma3server tmp/exile
	cd tmp/exile
else
	cd tmp/exile/
fi

# check if mod/lgsm is downloaded. if not, download them.
#COMMENT
echo -e "${CYAN}Downloading and extracting Exile and ExileServer mod.${NC}"
sleep 2
if [! `ls tmp/exile/linuxsgm.sh > /dv/null 2>&1`];
then
	sudo -u arma3server "wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh" ${USER}
fi

# prompt for steam creds, create lgsm config, start arma 3 server install
echo -e "${CYAN}Enter your steam username."
read steam_user
echo -e "Enter your steam password. If you have Steam Guard on you will be prompted for the code shortly. ${NC}"
read steam_pass

sudo -u arma3server echo "steamuser=\"$steam_user\"" > "lgsm/config-lgsm/arma3server/common.cfg"; echo "steampass=\"$steam_pass\"" >> "lgsm/config-lgsm/arma3server/common.cfg"
steam_user=""  # #security
steam_pass=""  # #security
sudo -u arma3server "./arma3server install"

: <<'COMMENT'
# unzip and cleanup of archive
if [ ! `ls -l @Exile/ > /dev/null 2>&1` ] || [ ! `ls -l "Arma 3 Server" > /dev/null 2>&1` ];
then
	unzip "@Exile-1.0.4.zip"
	rm "@Exile-1.0.4.zip"
	unzip "ExileServer-1.0.4a.zip"
	rm "ExileServer-1.0.4a.zip"
fi


# create dir and chown it to arma3server
if [ ! -d "arma" ];
then 
	mkdir arma
	chown $USER:$USER "arma"
	cd arma
else
	cd arma
fi

mv -r tmp/exile/@Exile arma/@exile
mv -r tmp/exile/"Arma 3 Server"/@ExileServer arma
COMMENT
