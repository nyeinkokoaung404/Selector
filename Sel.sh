#!/bin/bash
clear

# Enhanced Color Palette
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
BG_BLUE='\e[44m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'
BG='\033[44m'
FG_WHITE='\033[1;37m'

# UI Elements
CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
ARROW="${CYAN}➜${NC}"
STAR="${YELLOW}★${NC}"
HEART="${RED}♥${NC}"
LINE="${BLUE}$(printf '%*s' $(tput cols) | tr ' ' '═')${NC}"

# Function to display centered text
center() {
    termwidth=$(tput cols)
    padding="$(printf '%0.1s' ={1..500})"
    printf "${BG}${FG_WHITE}%*.*s %s %*.*s${NC}\n" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# System Information
show_system_info() {
    echo -e "${LINE}"
    echo -e "${STAR} ${GREEN}Hostname:${NC} $(hostname)"
    echo -e "${STAR} ${GREEN}IP Address:${NC} $(hostname -I | awk '{print $1}')"
    echo -e "${STAR} ${GREEN}Uptime:${NC} $(uptime -p)"
    echo -e "${STAR} ${GREEN}OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
    echo -e "${LINE}"
}

# Header with ASCII Art
display_header() {
    center "Server Management Toolkit"
    echo ""
    echo -e "${YELLOW}${BG_BLUE}"
    cat << "EOF"
+------------------------------------------------------------------+
|     _________         _________          _________               |
|    |\  \ |\  \        |\   __  \        |\  \ |\  \              |
|    \ \  \|_\  \       \ \  \|\  \       \ \  \|_\  \             |
|     \ \______  \       \ \  \/\  \       \ \______  \            |
|      \|_____|\  \       \ \  \/\  \       \|_____|\  \           |
|             \ \__\       \ \_______\             \ \__\          |
|              \|__|        \|_______|              \|__|          |
+------------------------------------------------------------------+
EOF
    echo -e "${NC}"
}

# Main Menu
show_menu() {
    echo -e "\n${MAGENTA}MAIN MENU - Please select an option:${NC}\n"
    echo -e "${ARROW} ${GREEN}0${NC} ◇ System Update & Upgrade"
    echo -e "${ARROW} ${GREEN}1${NC} ◇ Install MHSanaei 3X-UI (Xray Panel)"
    echo -e "${ARROW} ${GREEN}2${NC} ◇ Install Alireza0 3X-UI (Alternative Panel)"
    echo -e "${ARROW} ${GREEN}3${NC} ◇ Install 4-0-4 UDP Speed Boost"
    echo -e "${ARROW} ${GREEN}4${NC} ◇ Install UDP Custom Manager"
    echo -e "${ARROW} ${GREEN}5${NC} ◇ Install DARKSSH Manager"
    echo -e "${ARROW} ${GREEN}6${NC} ◇ Install 404-SSH Manager"
    echo -e "${ARROW} ${GREEN}7${NC} ◇ Install ZI-VPN"
    echo -e "${ARROW} ${GREEN}8${NC} ◇ Uninstall ZI-VPN"
    echo -e "${ARROW} ${RED}404${NC} ◇ Install Selector Tool"
    echo -e "${ARROW} ${YELLOW}help${NC} ◇ Show Help Information"
    echo -e "${ARROW} ${RED}exit${NC} ◇ Quit Program"
    echo -e "${LINE}"
}

# Help Information
show_help() {
    echo -e "\n${YELLOW}HELP INFORMATION:${NC}"
    echo -e "${ARROW} This tool provides quick installation of various server management utilities."
    echo -e "${ARROW} Each option will download and install the selected software automatically."
    echo -e "${ARROW} Ensure you have proper permissions before running installations."
    echo -e "${LINE}"
}

# Installation Functions
install_option() {
    case $1 in
        0)
            echo -e "${CHECK} Performing system update..."
            apt update && apt upgrade -y
            ;;
        1)
            echo -e "${CHECK} Installing MHSanaei 3X-UI..."
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
            ;;
        2)
            echo -e "${CHECK} Installing Alireza0 3X-UI..."
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            ;;
        3)
            echo -e "${CHECK} Installing 4-0-4 UDP Script..."
            git clone https://github.com/nyeinkokoaung404/udp-custom && cd udp-custom && chmod +x install.sh && ./install.sh
            ;;
        4)
            echo -e "${CHECK} Installing UDP Custom Manager..."
            wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh && chmod +x install.sh && bash install.sh
            ;;
        5)
            echo -e "${CHECK} Installing DARKSSH Manager..."
            wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark; chmod 777 Dark; ./Dark
            ;;
        6)
            echo -e "${CHECK} Installing 404-SSH Manager..."
            wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe; chmod 777 hehe;./hehe
            ;;
        7)
            echo -e "${CHECK} Installing ZI-VPN..."
            wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh; sudo chmod +x zi.sh; sudo ./zi.sh
            ;;
        8)
            echo -e "${CHECK} Uninstalling ZI-VPN..."
            sudo wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh; sudo chmod +x ziun.sh; sudo ./ziun.sh
            ;;
        404)
            echo -e "${CHECK} Installing Selector Tool..."
            bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
            echo -e "\n${STAR} ${GREEN}Installation complete! You can now run the tool with '404' command.${NC}"
            ;;
        *)
            echo -e "${CROSS} ${RED}Invalid option!${NC}"
            return 1
            ;;
    esac
    return 0
}

# Main Program Flow
display_header
show_system_info

while true; do
    show_menu
    
    echo -en "${HEART} ${CYAN}Enter your choice (0-8/404/help/exit):${NC} "
    read -r user_input
    
    case $user_input in
        help)
            show_help
            continue
            ;;
        exit)
            echo -e "${CHECK} ${GREEN}Thank you for using the tool! Goodbye.${NC}\n"
            exit 0
            ;;
        *)
            if [[ "$user_input" =~ ^(0|1|2|3|4|5|6|7|8|404)$ ]]; then
                install_option "$user_input"
                echo -e "${LINE}"
                echo -e "${CHECK} ${GREEN}Operation completed successfully!${NC}"
                echo -e "${STAR} ${YELLOW}You may now run another operation or exit.${NC}\n"
            else
                echo -e "${CROSS} ${RED}Invalid input! Please enter a valid option.${NC}\n"
            fi
            ;;
    esac
done
