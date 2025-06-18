#!/bin/bash
clear

## ---------------------------
## Global Variables
## ---------------------------
# Color Palette
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# UI Elements
ARROW="${CYAN}➜${NC}"
STAR="${YELLOW}✰${NC}"

# Script Info
SCRIPT_VERSION="2.2"
DEVELOPER="404"
CONTACT="t.me/nkka404"

## ---------------------------
## Initial Checks
## ---------------------------

# Root check
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root!${NC}"
    exit 1
fi

# Install dependencies
check_dependencies() {
    local dependencies=("figlet" "screen")
    for dep in "${dependencies[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${YELLOW}Installing $dep...${NC}"
            apt-get update && apt-get install -y $dep
        fi
    done
}
check_dependencies

## ---------------------------
## Display Functions
## ---------------------------

center_text() {
    local text="$1"
    local color="$2"
    local termwidth=$(tput cols)
    local padding=$(( (termwidth - ${#text}) / 2 ))
    printf "%*s${color}%s${NC}\n" $padding "" "$text"
}

show_header() {
    clear
    center_text "Server Management Toolkit" $PURPLE
    center_text "Developed by $DEVELOPER | Version $SCRIPT_VERSION | $CONTACT" $CYAN
    echo
}

show_system_info() {
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║          ${WHITE}System Information${GREEN}          ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}Hostname:${NC} $(hostname)"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}IP:${NC} $(hostname -I | awk '{print $1}')"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}Uptime:${NC} $(uptime -p)"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}')"
    echo -e "${GREEN}║${NC} ${STAR} ${GREEN}Disk:${NC} $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
}

## ---------------------------
## Core Functions
## ---------------------------

system_update() {
    echo -e "${YELLOW}Updating system packages...${NC}"
    apt update && apt upgrade -y
    echo -e "${GREEN}System update completed!${NC}"
}

clean_cache() {
    echo -e "${YELLOW}Cleaning system cache...${NC}"
    apt clean && apt autoclean
    echo -e "${GREEN}Cache cleaned successfully!${NC}"
}

check_disk() {
    echo -e "${YELLOW}Disk space usage:${NC}"
    df -h
}

install_mhsanaei() {
    echo -e "${YELLOW}Installing MHSanaei 3X-UI...${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
}

install_alireza() {
    echo -e "${YELLOW}Installing Alireza0 3X-UI...${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
}

install_zivpn() {
    echo -e "${YELLOW}Installing ZI-VPN...${NC}"
    wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
    chmod +x zi.sh
    ./zi.sh
}

uninstall_zivpn() {
    echo -e "${YELLOW}Uninstalling ZI-VPN...${NC}"
    wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
    chmod +x ziun.sh
    ./ziun.sh
}

install_404udp() {
    echo -e "${YELLOW}Installing 404 UDP Boost...${NC}"
    git clone https://github.com/nyeinkokoaung404/udp-custom
    cd udp-custom && chmod +x install.sh
    ./install.sh
}

install_udpmanager() {
    echo -e "${YELLOW}Installing UDP Custom Manager...${NC}"
    wget https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh -O install.sh
    chmod +x install.sh
    bash install.sh
}

install_darkssh() {
    echo -e "${YELLOW}Installing DARKSSH Manager...${NC}"
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
    chmod 777 Dark
    ./Dark
}

install_404ssh() {
    echo -e "${YELLOW}Installing 404-SSH Manager...${NC}"
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
    chmod 777 hehe
    ./hehe
}

install_selector() {
    echo -e "${YELLOW}Installing Selector Tool...${NC}"
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
}

run_benchmark() {
    echo -e "${YELLOW}Running server benchmark...${NC}"
    curl -sL yabs.sh | bash
}

install_rdp() {
    echo -e "${YELLOW}Installing RDP service...${NC}"
    screen -dmS rdp-installer bash -c '
        (wget https://tinyinstaller.top/setup.sh -4O tinyinstaller.sh || curl https://tinyinstaller.top/setup.sh -Lo tinyinstaller.sh) && bash tinyinstaller.sh free
    '
    echo -e "${GREEN}RDP installation started in background session.${NC}"
    echo -e "Use ${CYAN}screen -r rdp-installer${NC} to view progress"
}

update_script() {
    echo -e "${YELLOW}Checking for updates...${NC}"
    latest_version=$(curl -s $SCRIPT_URL | grep "SCRIPT_VERSION=" | cut -d'"' -f2)
    
    if [ "$latest_version" != "$SCRIPT_VERSION" ]; then
        echo -e "${GREEN}New version available: $latest_version${NC}"
        echo -e "${YELLOW}Updating...${NC}"
        wget -O $0 $SCRIPT_URL
        echo -e "${GREEN}Update complete! Restarting script...${NC}"
        exec $0
    else
        echo -e "${GREEN}You have the latest version ($SCRIPT_VERSION)${NC}"
    fi
}

show_help() {
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║            ${WHITE}Help Information${GREEN}            ║${NC}"
    echo -e "${GREEN}╠════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC} ${ARROW} Enter option number to execute command"
    echo -e "${GREEN}║${NC} ${ARROW} Type ${CYAN}help${NC} to show this message"
    echo -e "${GREEN}║${NC} ${ARROW} Type ${CYAN}exit${NC} to quit the program"
    echo -e "${GREEN}║${NC}"
    echo -e "${GREEN}║${NC} ${GREEN}System Management:${NC} 0-3"
    echo -e "${GREEN}║${NC} ${YELLOW}VPN Panels:${NC} 10-13"
    echo -e "${GREEN}║${NC} ${CYAN}Speed Tools:${NC} 20-21"
    echo -e "${GREEN}║${NC} ${BLUE}SSH Managers:${NC} 30-31"
    echo -e "${GREEN}║${NC} ${PURPLE}Other Tools:${NC} 40-41,50"
    echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
}

## ---------------------------
## Menu System
## ---------------------------

show_menu() {
    show_header
    show_system_info
    
    echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║      ${WHITE}Server Management Menu${GREEN}       ║${NC}"
    echo -e "${GREEN}╠══════════════════════╦═══════════════════╣${NC}"
    echo -e "${GREEN}║ ${CYAN}[0]${NC} System Update    ║ ${YELLOW}[10]${NC} MHSanaei 3X-UI ║${NC}"
    echo -e "${GREEN}║ ${CYAN}[1]${NC} Clean Cache      ║ ${YELLOW}[11]${NC} Alireza0 3X-UI ║${NC}"
    echo -e "${GREEN}║ ${CYAN}[2]${NC} Check Disk      ║ ${YELLOW}[12]${NC} Install ZI-VPN ║${NC}"
    echo -e "${GREEN}║ ${CYAN}[3]${NC} Update Script   ║ ${YELLOW}[13]${NC} Remove ZI-VPN  ║${NC}"
    echo -e "${GREEN}╠══════════════════════╩═══════════════════╣${NC}"
    echo -e "${GREEN}║ ${BLUE}[20]${NC} 404 UDP Boost  ║ ${PURPLE}[30]${NC} DARKSSH      ║${NC}"
    echo -e "${GREEN}║ ${BLUE}[21]${NC} UDP Manager    ║ ${PURPLE}[31]${NC} 404-SSH      ║${NC}"
    echo -e "${GREEN}╠══════════════════════╦═══════════════════╣${NC}"
    echo -e "${GREEN}║ ${PURPLE}[40]${NC} Selector      ║ ${RED}[50]${NC} Install RDP  ║${NC}"
    echo -e "${GREEN}║ ${PURPLE}[41]${NC} Benchmark     ║ ${RED}help${NC} Show Help    ║${NC}"
    echo -e "${GREEN}║                      ║ ${RED}exit${NC} Quit        ║${NC}"
    echo -e "${GREEN}╚══════════════════════╩═══════════════════╝${NC}"
}

## ---------------------------
## Main Program
## ---------------------------

while true; do
    show_menu
    
    echo -en "${ARROW} ${CYAN}Enter your choice:${NC} "
    read -r user_input
    
    case $user_input in
        0) system_update ;;
        1) clean_cache ;;
        2) check_disk ;;
        3) update_script ;;
        10) install_mhsanaei ;;
        11) install_alireza ;;
        12) install_zivpn ;;
        13) uninstall_zivpn ;;
        20) install_404udp ;;
        21) install_udpmanager ;;
        30) install_darkssh ;;
        31) install_404ssh ;;
        40) install_selector ;;
        41) run_benchmark ;;
        50) install_rdp ;;
        help) show_help ;;
        exit) 
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *) 
            echo -e "${RED}Invalid option!${NC}"
            ;;
    esac
    
    echo -e "${YELLOW}Press any key to continue...${NC}"
    read -n 1 -s -r
done
