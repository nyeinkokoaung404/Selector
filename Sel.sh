#!/bin/bash
clear

## ---------------------------
## Global Variables
## ---------------------------
# Enhanced Color Palette
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
BG_BLUE='\e[44m'
BG_GREEN='\e[42m'
BG_RED='\e[41m'
NC='\033[0m'

# UI Elements
CHECK="${GREEN}✔${NC}"
CROSS="${RED}✖${NC}"
ARROW="${CYAN}➜${NC}"
STAR="${YELLOW}✰${NC}"
HEART="${RED}❤${NC}"
DIAMOND="${BLUE}♦${NC}"
LINE="${BLUE}$(printf '%*s' $(tput cols) | tr ' ' '─')${NC}"
DOUBLE_LINE="${PURPLE}$(printf '%*s' $(tput cols) | tr ' ' '═')${NC}"

# System Info
OS_INFO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p | sed 's/up //')

## ---------------------------
## Functions
## ---------------------------

# Function to display centered text with borders
center() {
    local termwidth=$(tput cols)
    local title="$1"
    local color="$2"
    local border_char="$3"
    
    local border=$(printf "%*s" "$termwidth" | tr ' ' "$border_char")
    local padding=$(( (termwidth - ${#title} - 2) / 2 ))
    
    echo -e "${color}${border}${NC}"
    printf "%*s %s %*s\n" $padding "" "${color}${title}${NC}" $padding ""
    echo -e "${color}${border}${NC}"
}

# Animated progress spinner
spinner() {
    local pid=$!
    local delay=0.1
    local spinstr='|/-\'
    
    tput civis # Hide cursor
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c] " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b"
    done
    tput cnorm # Show cursor
    printf "    \b\b\b\b"
}

# Display system information
show_system_info() {
    echo -e "${DOUBLE_LINE}"
    echo -e "${STAR} ${GREEN}Hostname:${NC} $(hostname)"
    echo -e "${STAR} ${GREEN}IP Address:${NC} $IP_ADDRESS"
    echo -e "${STAR} ${GREEN}Uptime:${NC} $UPTIME"
    echo -e "${STAR} ${GREEN}OS:${NC} $OS_INFO"
    echo -e "${STAR} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo -e "${STAR} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}')"
    echo -e "${DOUBLE_LINE}"
}

# Beautiful header with ASCII art
display_header() {
    clear
    
    # Get terminal width
    local termwidth=$(tput cols)
    
    # Display header with borders
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗" | awk -v termwidth="$termwidth" '{printf "%*s\n", (termwidth+82)/2, $0}'
    echo "║                                                                              ║" | awk -v termwidth="$termwidth" '{printf "%*s\n", (termwidth+82)/2, $0}'
    
    # Display the requested ASCII art with proper centering
    echo -e "${YELLOW}"
    cat << "EOF" | awk -v termwidth="$termwidth" '
    {
        spaces = int((termwidth - 70) / 2)
        printf "%" spaces "s%s\n", "", $0
    }
    '
    |     _________         _________          _________               |
    |    |\  \ |\  \        |\   __  \        |\  \ |\  \              |
    |    \ \  \|_\  \       \ \  \|\  \       \ \  \|_\  \             |
    |     \ \______  \       \ \  \/\  \       \ \______  \            |
    |      \|_____|\  \       \ \  \/\  \       \|_____|\  \           |
    |             \ \__\       \ \_______\             \ \__\          |
    |              \|__|        \|_______|              \|__|          |
EOF
    echo -e "${BLUE}"
    echo "║                                                                              ║" | awk -v termwidth="$termwidth" '{printf "%*s\n", (termwidth+82)/2, $0}'
    echo "╚══════════════════════════════════════════════════════════════════════════════╝" | awk -v termwidth="$termwidth" '{printf "%*s\n", (termwidth+82)/2, $0}'
    echo -e "${NC}"
    
    center "Server Management Toolkit v2.0" $PURPLE "═"
}

# Beautiful menu with categories
show_menu() {
    echo -e "\n${WHITE}╒══════════════════════════════════════════════════════════════════════════════╕${NC}"
    echo -e "${WHITE}│${NC} ${PURPLE}MAIN MENU - Please select an option:${NC} ${WHITE}│${NC}"
    echo -e "${WHITE}╞══════════════════════════════════════════════════════════════════════════════╡${NC}"
    
    # System Management
    echo -e "${WHITE}│${NC} ${GREEN}System Management:${NC}"
    echo -e "${WHITE}│${NC} ${ARROW} ${GREEN}[0]${NC} ◇ System Update & Upgrade"
    echo -e "${WHITE}│${NC} ${ARROW} ${GREEN}[1]${NC} ◇ Clean System Cache"
    echo -e "${WHITE}│${NC} ${ARROW} ${GREEN}[2]${NC} ◇ Check Disk Space"
    echo -e "${WHITE}│${NC}"
    
    # VPN Panels
    echo -e "${WHITE}│${NC} ${YELLOW}VPN Panels:${NC}"
    echo -e "${WHITE}│${NC} ${ARROW} ${YELLOW}[10]${NC} ◇ Install MHSanaei 3X-UI (MHSanaei Xray Panel)"
    echo -e "${WHITE}│${NC} ${ARROW} ${YELLOW}[11]${NC} ◇ Install Alireza0 3X-UI (Alternative Xray Panel)"
    echo -e "${WHITE}│${NC} ${ARROW} ${YELLOW}[12]${NC} ◇ Install ZI-VPN"
    echo -e "${WHITE}│${NC} ${ARROW} ${YELLOW}[13]${NC} ◇ Uninstall ZI-VPN"
    echo -e "${WHITE}│${NC}"
    
    # Speed Optimization
    echo -e "${WHITE}│${NC} ${CYAN}Speed Optimization:${NC}"
    echo -e "${WHITE}│${NC} ${ARROW} ${CYAN}[20]${NC} ◇ Install 4-0-4 UDP Speed Boost"
    echo -e "${WHITE}│${NC} ${ARROW} ${CYAN}[21]${NC} ◇ Install UDP Custom Manager"
    echo -e "${WHITE}│${NC}"
    
    # SSH Managers
    echo -e "${WHITE}│${NC} ${BLUE}SSH Managers:${NC}"
    echo -e "${WHITE}│${NC} ${ARROW} ${BLUE}[30]${NC} ◇ Install DARKSSH Manager"
    echo -e "${WHITE}│${NC} ${ARROW} ${BLUE}[31]${NC} ◇ Install 404-SSH Manager"
    echo -e "${WHITE}│${NC}"
    
    # Tools
    echo -e "${WHITE}│${NC} ${MAGENTA}Tools:${NC}"
    echo -e "${WHITE}│${NC} ${ARROW} ${MAGENTA}[40]${NC} ◇ Install Selector Tool (404)"
    echo -e "${WHITE}│${NC} ${ARROW} ${MAGENTA}[41]${NC} ◇ Server Benchmark"
    echo -e "${WHITE}│${NC}"
    
    # Other
    echo -e "${WHITE}│${NC} ${RED}Other:${NC}"
    echo -e "${WHITE}│${NC} ${ARROW} ${RED}help${NC} ◇ Show Help Information"
    echo -e "${WHITE}│${NC} ${ARROW} ${RED}exit${NC} ◇ Quit Program"
    echo -e "${WHITE}╘══════════════════════════════════════════════════════════════════════════════╛${NC}"
}

# Installation Functions
install_option() {
    case $1 in
        0)
            echo -e "${CHECK} Performing System Update..."
            apt update && apt upgrade -y &
            spinner
            echo -e "\n${CHECK} ${GREEN}System Updated Successfully!${NC}"
            ;;
        1)
            echo -e "${CHECK} Cleaning System Cache..."
            apt clean && apt autoclean &
            spinner
            echo -e "\n${CHECK} ${GREEN}System Cache Cleaned!${NC}"
            ;;
        2)
            echo -e "${CHECK} Checking Disk Space..."
            df -h
            ;;
        10)
            echo -e "${CHECK} Installing MHSanaei 3X-UI..."
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
            ;;
        11)
            echo -e "${CHECK} Installing Alireza0 3X-UI..."
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            ;;
        12)
            echo -e "${CHECK} Installing ZI-VPN..."
            wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh; sudo chmod +x zi.sh; sudo ./zi.sh
            ;;
        13)
            echo -e "${CHECK} Uninstalling ZI-VPN..."
            wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh; sudo chmod +x ziun.sh; sudo ./ziun.sh
            ;;
        20)
            echo -e "${CHECK} Installing 4-0-4 UDP Script..."
            git clone https://github.com/nyeinkokoaung404/udp-custom && cd udp-custom && chmod +x install.sh && ./install.sh
            ;;
        21)
            echo -e "${CHECK} Installing UDP Custom Manager..."
            wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh && chmod +x install.sh && bash install.sh
            ;;
        30)
            echo -e "${CHECK} Installing DARKSSH Manager..."
            wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark; chmod 777 Dark; ./Dark
            ;;
        31)
            echo -e "${CHECK} Installing 404-SSH Manager..."
            wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe; chmod 777 hehe;./hehe
            ;;
        40)
            echo -e "${CHECK} Installing Selector Tool..."
            bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
            echo -e "\n${STAR} ${GREEN}Installation complete! You can now run the tool with '404' command.${NC}"
            ;;
        41)
            echo -e "${CHECK} Running Server Benchmark..."
            curl -sL yabs.sh | bash
            ;;
        *)
            echo -e "${CROSS} ${RED}Invalid Option!${NC}"
            return 1
            ;;
    esac
    return 0
}

# Help Information
show_help() {
    center "HELP INFORMATION" $CYAN "─"
    echo -e "${ARROW} ${GREEN}This tool provides quick installation of various server management utilities.${NC}"
    echo -e "${ARROW} ${YELLOW}Each option will download and install the selected software automatically.${NC}"
    echo -e "${ARROW} ${RED}Ensure you have proper permissions before running installations.${NC}"
    echo -e "\n${STAR} ${BLUE}Key Features:${NC}"
    echo -e "  ${DIAMOND} System Maintenance Tools"
    echo -e "  ${DIAMOND} VPN Xray Panel Installations"
    echo -e "  ${DIAMOND} Network Speed Optimization"
    echo -e "  ${DIAMOND} SSH Management Utilities"
    echo -e "${DOUBLE_LINE}"
}

## ---------------------------
## Main Program
## ---------------------------
display_header
show_system_info

while true; do
    show_menu
    
    echo -en "${HEART} ${CYAN}Enter your choice (0-41/help/exit):${NC} "
    read -r user_input
    
    case $user_input in
        help)
            show_help
            continue
            ;;
        exit)
            echo -e "${CHECK} ${GREEN}Thank you for using the Server Management Toolkit! Goodbye.${NC}\n"
            exit 0
            ;;
        *)
            if [[ "$user_input" =~ ^[0-9]+$ ]]; then
                install_option "$user_input"
                echo -e "${LINE}"
                echo -e "${CHECK} ${GREEN}Operation Completed Successfully!${NC}"
                echo -e "${STAR} ${YELLOW}Press any key to return to the menu...${NC}"
                read -n 1 -s -r
            else
                echo -e "${CROSS} ${RED}Invalid input! Please enter a valid option.${NC}\n"
                echo -e "${STAR} ${YELLOW}Press any key to continue...${NC}"
                read -n 1 -s -r
            fi
            ;;
    esac
done
