#!/bin/bash
clear
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
plain='\033[0m'
NC='\033[0m' # No Color


echo "+------------------------------------------------------------------+"
echo "|     ___   ___          ________          ___   ___               |"
echo "|    |\  \ |\  \        |\   __  \        |\  \ |\  \              |"
echo "|    \ \  \|_\  \       \ \  \|\  \       \ \  \|_\  \             |"
echo "|     \ \______  \       \ \  \/\  \       \ \______  \            |"
echo "|      \|_____|\  \       \ \  \/\  \       \|_____|\  \           |"
echo "|             \ \__\       \ \_______\             \ \__\          |"
echo "|              \|__|        \|_______|              \|__|          |"
echo "+------------------------------------------------------------------+"
echo -e "| Telegram Account : ${GREEN}@nkka404 ${NC}|Telegram Channel : ${RED}t.me/premium_channel_404${NC} |"
echo "+------------------------------------------------------------------+"
echo ""

echo -e "********************************************************************"
echo -e "\e[1;32mPlease choose an option:(Type 404 to install selector)\e[0m"
echo -e "********************************************************************"
echo ""
echo "+------------------------------------------------------------------+"
echo -e "|${GREEN}0 ◇ GET APT UPDATE & UPGRADE"
echo "+------------------------------------------------------------------+"
echo -e "|${GREEN}1 ◇ MHSanaei 3X-UI"
echo -e "|${GREEN}2 ◇ Alireza0 3X-UI"
echo -e "|${GREEN}3 ◇ 4-0-4 UDP SCRIPT"
echo -e "|${GREEN}4 ◇ UDP CUSTOM MANGER"
echo -e "|${GREEN}5 ◇ DARKSSH-MANAGER"
echo -e "|${GREEN}6 ◇ 404-SSH-MANAGER"
echo "+------------------------------------------------------------------+"
echo -en "|${YELLOW}Please choose an option:"
read -r user_input
# echo "+------------------------------------------------------------------+"
# Execute the chosen option
if [ "$user_input" -eq 0 ]; then
    apt update -y && apt install -y curl socat wget
elif [ "$user_input" -eq 1 ]; then
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
elif [ "$user_input" -eq 2 ]; then
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
elif [ "$user_input" -eq 3 ]; then
    git clone https://github.com/nyeinkokoaung404/udp-custom && cd udp-custom && chmod +x install.sh && ./install.sh
elif [ "$user_input" -eq 4 ]; then
    wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh && chmod +x install.sh && bash install.sh
elif [ "$user_input" -eq 5 ]; then
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark; chmod 777 Dark; ./Dark
elif [ "$user_input" -eq 6 ]; then
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe; chmod 777 hehe;./hehe
elif [ "$user_input" -eq 404 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    echo -e "\e[1;32mAfter this, you can run the Selector with \e[1;36m404 \e[1;32mcommand\e[0m"
    else 
    echo "Invalid input. Please enter between 1 and 6"
fi
