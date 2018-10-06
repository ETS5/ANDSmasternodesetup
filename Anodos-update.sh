#!/bin/bash

COIN_PATH='/usr/bin/'
COIN_TGZ='https://github.com/AnodosCore/AnodosCore/releases/download/V2.0/Anodos.Ubuntu.VPS.16.04.tar.gz'
COIN_ZIP=$(echo $COIN_TGZ | awk -F'/' '{print $NF}')

#!/bin/bash
# Anodos Update Script
# (c) 2018 by ETS5 for Anodos Coin 
#
# Usage:
# bash Anodos-update.sh 
#

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color



#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }

echo -e "${YELLOW}Anodos Update Script v0.1${NC}"

#KILL THE MFER
echo -e "${YELLOW}Killing deamon...${NC}"
function stop_daemon {
    if pgrep -x 'anodosd' > /dev/null; then
        echo -e "${YELLOW}Attempting to stop anodosd${NC}"
        anodos-cli stop
        delay 30
        if pgrep -x 'anodos' > /dev/null; then
            echo -e "${RED}anodosd daemon is still running!${NC} \a"
            echo -e "${RED}Attempting to kill...${NC}"
            pkill anodosd
            delay 30
            if pgrep -x 'anodosd' > /dev/null; then
                echo -e "${RED}Can't stop anodosd! Reboot and try again...${NC} \a"
                exit 2
            fi
        fi
    fi
}
#Function detect_ubuntu

 if [[ $(lsb_release -d) == *16.04* ]]; then
   UBUNTU_VERSION=16
else
   echo -e "${RED}You are not running Ubuntu 16.04, Installation is cancelled.${NC}"
   exit 1

fi


#Delete .anodoscore contents 
echo -e "${YELLOW}Scrapping .anodoscore...${NC}"
cd 
cd ~/.anodoscore
rm -rf c* b* w* p* n* m* f* d* g*

#Delete OLD Binary
echo -e "${YELLOW}Deleting v1.3...${NC}"
cd ~
rm -rf ~/anodos
rm -rf ~/usr/bin/anodos*

#Install new Binaries
echo -e "${YELLOW}Installing v1.0.1...${NC}"
cd ~
mkdir Anodos
cd Anodos
wget $COIN_TGZ
tar xzf $COIN_ZIP >/dev/null 2>&1 
rm -r $COIN_ZIP >/dev/null 2>&1

sudo cp ~/anodos/anodos* $COIN_PATH
sudo chmod 755 -R ~/anodos
sudo chmod 755 /usr/bin/anodos*

#Restarting Daemon
    anodosd -daemon
echo -ne '[##                 ] (15%)\r'
sleep 6
echo -ne '[######             ] (30%)\r'
sleep 6
echo -ne '[########           ] (45%)\r'
sleep 6
echo -ne '[##############     ] (72%)\r'
sleep 10
echo -ne '[###################] (100%)\r'
echo -ne '\n'

echo -e "${GREEN}Your masternode is now up to date${NC}"
# Run nodemon.sh
andsmon.sh
# EOF
