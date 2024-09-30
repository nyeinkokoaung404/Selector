#!/bin/bash
clear



echo "+------------------------------------------------------------------+"
echo "|     ___   ___          ________          ___   ___               |"
echo "|    |\  \ |\  \        |\   __  \        |\  \ |\  \              |"
echo "|    \ \  \|_\  \       \ \  \|\  \       \ \  \|_\  \             |"
echo "|     \ \______  \       \ \  \/\  \       \ \______  \            |"
echo "|      \|_____|\  \       \ \  \/\  \       \|_____|\  \           |"
echo "|             \ \__\       \ \_______\             \ \__\          |"
echo "|              \|__|        \|_______|              \|__|          |"
echo "+------------------------------------------------------------------+"
echo -e "| Telegram Account : ${GREEN}@nkka404 ${NC}|For More : ${RED}Information..${NC} |"
echo "+-----------------------------------------------------------------------+"
echo ""

echo -e "\e[1;36m*****************************************"
echo -e "\e[1;32mPlease choose an option:(Type 404 to install selector)\e[0m"
echo -e "\e[1;36m*****************************************"
# echo -e "\e[1;35m*\e[0m \e[1;31mV\e[1;32mP\e[1;33mS-\e[1;34mS\e[1;35mC\e[1;36mR\e[1;37mI\e[1;31mP\e[0mT \e[4;34mBy 4-0-4\e[0m         \e[1;35m"
# echo -e "\e[1;36m*****************************************"
# echo -e "\e[1;36m1. \e[1;33m MHSanaei 3x-ui\e[0m"
# echo -e "\e[1;36m2. \e[1;33m Alireza0 3x-ui\e[0m"
# echo -e "\e[1;36m3. \e[1;33m 4-0-4 UDP Script\e[0m"
# echo -e "\e[1;36m4. \e[1;33m UDP Custom Manger\e[0m"
# echo -e "\e[1;36m5. \e[1;33m SSH Script\e[0m"
# echo -e "\e[1;36m*****************************************"
echo "+-----------------------------------------------------------------------+"                                                                                                
echo -e "|${GREEN}1.MHSanaei 3X-UI"
echo -e "|${GREEN}2.Alireza0 3X-UI"
echo -e "|${GREEN}3.4-0-4 UDP SCRIPT"
echo -e "|${GREEN}4.UDP CUSTOM MANGER"
echo -e "|${GREEN}5.SSH SCRIPT"
echo "+-----------------------------------------------------------------------+"                                                                                                
echo -en "|${YELLOW}Please choose an option:"
echo "+-----------------------------------------------------------------------+"
# echo -en "\e[1;32mEnter your choice:\e[0m"
read -r user_input

# Execute the chosen option
if [ "$user_input" -eq 1 ]; then
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
elif [ "$user_input" -eq 2 ]; then
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
elif [ "$user_input" -eq 3 ]; then
    git clone https://github.com/nyeinkokoaung404/udp-custom && cd udp-custom && chmod +x install.sh && ./install.sh
elif [ "$user_input" -eq 4 ]; then
    wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh && chmod +x install.sh && bash install.sh
elif [ "$user_input" -eq 5 ]; then
    apt-get update -y; apt-get upgrade -y; wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark; chmod 777 Dark; ./Dark
elif [ "$user_input" -eq 404 ]; then
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    echo -e "\e[1;32mAfter this, you can run the Selector with \e[1;36m404 \e[1;32mcommand\e[0m"
    else 
    echo "Invalid input. Please enter between 1 and 5"
fi
