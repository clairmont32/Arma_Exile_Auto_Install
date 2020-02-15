#!/bin/bash

# create user for server
USER="arma3server"
echo -e "${CYAN}Creating a user for the arma server to run under... #security${NC}"
sleep 1
# check if user already exists. if not, create it
if [ `id -u $USER 2>/dev/null || echo -1` -ge 0 ];
then	
	echo -e "${CYAN}$USER already present... proceeding."
else
	#echo -e "${CYAN}Enter a password for the new user:${NC}"
	# read USER_PASSWORD
	useradd -m -p abc -s /bin/bash arma3server
	cd /home/arma3server
	pwd
fi

# install dependencies 
apt-get install gcc libssl-dev -y
add-apt-repository ppa:koffeinflummi/armake
apt-get update
apt-get install armake tree
dpkg sudo dpkg --add-architecture i386; sudo apt update; sudo apt install mailutils postfix curl wget file tar bzip2 gzip unzip bsdmainutils python util-linux ca-certificates binutils bc jq tmux lib32gcc1 libstdc++6 libstdc++6:i386

# downloadand install lgsm
sudo su arma3server -c "cd /home/arma3server && wget -O linuxgsm.sh https://linuxgsm.sh && chmod +x linuxgsm.sh && bash linuxgsm.sh arma3server"

# prompt for steam creds, create lgsm config, start arma 3 server install
mkdir lgsm/config-lgsm
mkdir lgsm/config-lgsm/arma3server
echo "Enter your steam username\n"
read STEAMUSER
echo "Enter your steam password\n"
read STEAMPASS
echo "steamuser=\"$STEAMUSER\"" >> lgsm/config-lgsm/arma3server/common.cfg
echo "steampass=\"$STEAMPASS\"" >> lgsm/config-lgsm/arma3server/common.cfg
wc -l lgsm/config-lgsm/arma3server/common.cfg
cd /home/arma3server
chown -R arma3server:arma3server *
su arma3server -c "./arma3server install"
su arma3server -c "./arma3server start"
