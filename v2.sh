#!/bin/bash
clear

## ---------------------------
## Global Configuration
## ---------------------------
# Color Definitions
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Script Metadata
VERSION="2.2"
AUTHOR="404"
CONTACT="t.me/nkka404"
REPO_URL="https://github.com/yourrepo/yourscript"

## ---------------------------
## UI Functions
## ---------------------------

display_header() {
    clear
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════╗"
    echo "║      SERVER MANAGEMENT TOOLKIT         ║"
    echo "║               v$VERSION                ║"
    echo "╚════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${CYAN}Developed by: $AUTHOR"
    echo -e "Contact: $CONTACT${NC}"
    echo
}

center_text() {
    local text="$1"
    local color="$2"
    local text_length=$(echo -n "$text" | wc -m)
    local term_width=$(tput cols)
    local padding=$(( (term_width - text_length) / 2 ))
    
    printf "%${padding}s" ""
    echo -e "${color}${text}${NC}"
}

draw_box() {
    local title="$1"
    local color="$2"
    
    echo -e "${color}"
    center_text "╔════════════════════════════════════════╗"
    center_text "║           $title            ║"
    center_text "╠════════════════════════════════════════╣"
    echo -e "${NC}"
}

show_system_info() {
    draw_box "SYSTEM INFORMATION" $GREEN
    
    echo -e "${GREEN}║ ${WHITE}• Hostname:${NC} $(hostname)"
    echo -e "${GREEN}║ ${WHITE}• IP Address:${NC} $(hostname -I | awk '{print $1}')"
    echo -e "${GREEN}║ ${WHITE}• Uptime:${NC} $(uptime -p)"
    echo -e "${GREEN}║ ${WHITE}• OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
    echo -e "${GREEN}║ ${WHITE}• CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
    echo -e "${GREEN}║ ${WHITE}• Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}')"
    echo -e "${GREEN}║ ${WHITE}• Disk Usage:${NC} $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')"
    
    center_text "╚════════════════════════════════════════╝" $GREEN
    echo
}

## ---------------------------
## Core Functions
## ---------------------------

system_update() {
    draw_box "SYSTEM UPDATE" $YELLOW
    echo -e "${YELLOW}Updating package lists...${NC}"
    apt update
    echo -e "${YELLOW}Upgrading installed packages...${NC}"
    apt upgrade -y
    echo -e "${GREEN}System update completed successfully!${NC}"
}

clean_system() {
    draw_box "SYSTEM CLEANUP" $YELLOW
    echo -e "${YELLOW}Cleaning package cache...${NC}"
    apt clean
    echo -e "${YELLOW}Removing unnecessary packages...${NC}"
    apt autoremove -y
    echo -e "${GREEN}System cleanup completed!${NC}"
}

check_resources() {
    draw_box "SYSTEM RESOURCES" $BLUE
    echo -e "${BLUE}Memory Usage:${NC}"
    free -h
    echo
    echo -e "${BLUE}Disk Usage:${NC}"
    df -h
}

install_package() {
    local package_name="$1"
    local install_cmd="$2"
    
    draw_box "INSTALLING $package_name" $PURPLE
    echo -e "${PURPLE}Downloading and installing $package_name...${NC}"
    
    if eval "$install_cmd"; then
        echo -e "${GREEN}$package_name installed successfully!${NC}"
    else
        echo -e "${RED}Failed to install $package_name!${NC}"
    fi
}

## ---------------------------
## Main Menu
## ---------------------------

show_main_menu() {
    display_header
    show_system_info
    
    draw_box "MAIN MENU" $BLUE
    
    echo -e "${BLUE}║ ${CYAN}1. System Update                 ${BLUE}║"
    echo -e "${BLUE}║ ${CYAN}2. System Cleanup                ${BLUE}║"
    echo -e "${BLUE}║ ${CYAN}3. Check Resources               ${BLUE}║"
    echo -e "${BLUE}║ ${YELLOW}4. Install VPN Panel             ${BLUE}║"
    echo -e "${BLUE}║ ${YELLOW}5. Install Speed Tools           ${BLUE}║"
    echo -e "${BLUE}║ ${PURPLE}6. Install Management Tools      ${BLUE}║"
    echo -e "${BLUE}║ ${RED}7. Help & Information           ${BLUE}║"
    echo -e "${BLUE}║ ${RED}8. Exit                          ${BLUE}║"
    
    center_text "╚════════════════════════════════════════╝" $BLUE
    echo
}

## ---------------------------
## Initial Checks
## ---------------------------

# Verify root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}ERROR: This script must be run as root!${NC}"
    exit 1
fi

# Check dependencies
check_dependencies() {
    local dependencies=("figlet" "curl" "wget")
    local missing=()
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}Installing missing dependencies...${NC}"
        apt update && apt install -y "${missing[@]}"
    fi
}
check_dependencies

## ---------------------------
## Execution Loop
## ---------------------------

while true; do
    show_main_menu
    
    echo -ne "${CYAN}Enter your choice (1-8): ${NC}"
    read -r choice
    
    case $choice in
        1) system_update ;;
        2) clean_system ;;
        3) check_resources ;;
        4) 
            draw_box "VPN PANELS" $YELLOW
            echo -e "${YELLOW}1. MHSanaei 3X-UI"
            echo -e "2. Alireza0 3X-UI"
            echo -e "3. ZI-VPN${NC}"
            read -p "Select VPN panel: " vpn_choice
            ;;
        5) 
            draw_box "SPEED TOOLS" $PURPLE
            echo -e "${PURPLE}1. 404 UDP Boost"
            echo -e "2. UDP Custom Manager${NC}"
            read -p "Select speed tool: " speed_choice
            ;;
        6) 
            draw_box "MANAGEMENT TOOLS" $CYAN
            echo -e "${CYAN}1. DARKSSH Manager"
            echo -e "2. 404-SSH Manager"
            echo -e "3. Selector Tool${NC}"
            read -p "Select management tool: " mgmt_choice
            ;;
        7)
            draw_box "HELP & INFORMATION" $WHITE
            echo -e "${WHITE}This toolkit provides server management utilities."
            echo -e "Select options from the menu to perform actions."
            echo -e "Report issues to: $CONTACT${NC}"
            ;;
        8)
            echo -e "${GREEN}Thank you for using the Server Management Toolkit!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid selection! Please choose 1-8.${NC}"
            ;;
    esac
    
    echo
    read -n 1 -s -r -p "Press any key to continue..."
done
