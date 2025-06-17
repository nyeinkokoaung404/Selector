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
NC='\033[0m'

# Box Drawing Characters
BOX_HORIZ="═"
BOX_VERT="║"
BOX_CORNER_TL="╔"
BOX_CORNER_TR="╗"
BOX_CORNER_BL="╚"
BOX_CORNER_BR="╝"
BOX_T="╦"
BOX_B="╩"
BOX_L="╠"
BOX_R="╣"
BOX_CROSS="╬"

# UI Elements
CHECK="${GREEN}✔${NC}"
CROSS="${RED}✖${NC}"
ARROW="${CYAN}➜${NC}"
STAR="${YELLOW}✰${NC}"
HEART="${RED}❤${NC}"
DIAMOND="${BLUE}♦${NC}"

## ---------------------------
## Display Functions
## ---------------------------

# Function to center text on screen
center_text() {
    local text="$1"
    local color="$2"
    local termwidth=$(tput cols)
    local padding=$(( (termwidth - ${#text}) / 2 ))
    printf "%*s${color}%s${NC}\n" $padding "" "$text"
}

# Function to center multi-line content
center_content() {
    local content="$1"
    local color="$2"
    local termwidth=$(tput cols)
    
    while IFS= read -r line; do
        # Remove color codes for length calculation
        clean_line=$(echo -e "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        local line_len=${#clean_line}
        local padding=$(( (termwidth - line_len) / 2 ))
        printf "%*s${color}%s${NC}\n" $padding "" "$line"
    done <<< "$content"
}

# Beautiful header with centered title
display_header() {
    clear
    center_text "Server Management Toolkit v2.0" $PURPLE
    echo
}

# System information display centered
show_system_info() {
    local sysinfo=$(cat <<EOF
${STAR} ${GREEN}Hostname:${NC} $(hostname)
${STAR} ${GREEN}IP Address:${NC} $(hostname -I | awk '{print $1}')
${STAR} ${GREEN}Uptime:${NC} $(uptime -p | sed 's/up //')
${STAR} ${GREEN}OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
${STAR} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)
${STAR} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}' | tr -d ' ')
${STAR} ${GREEN}Disk Usage:${NC} $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')
EOF
)
    center_content "$sysinfo" ""
    
    # Display centered 404 with figlet
    echo
    echo -e "${RED}"
    figlet -f slant "4 0 4" | awk -v termwidth="$(tput cols)" '
    {
        spaces = int((termwidth - 70) / 2)
        printf "%" spaces "s%s\n", "", $0
    }'
    echo -e "${NC}"
    echo
}

# Beautiful header with box
display_header() {
    clear
    
    # Create box for title
    termwidth=$(tput cols)
    title="Server Management Toolkit v2.0"
    box_width=$(( ${#title} + 8 ))
    
    echo -ne "${PURPLE}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((box_width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"
    
    echo -ne "${PURPLE}${BOX_VERT}${NC}"
    printf "%*s" $(( (box_width - ${#title}) / 2 )) ""
    echo -ne "${WHITE}${title}${NC}"
    printf "%*s" $(( (box_width - ${#title} + 1) / 2 )) ""
    echo -e "${PURPLE}${BOX_VERT}${NC}"
    
    echo -ne "${PURPLE}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((box_width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

## ---------------------------
## Menu Layout (Improved)
## ---------------------------

show_menu() {
    echo -e "\n"
    
    # System Management and VPN Panels (side by side)
    echo -e "${GREEN}╔═════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   ${WHITE}System Management${GREEN}       ║   ${WHITE}VPN Panels                    ${NC}"
    echo -e "${GREEN}╠═════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${ARROW} ${GREEN}[0] System Update        ║${ARROW} ${YELLOW}[10] MHSanaei 3X-UI     ${NC}"
    echo -e "${GREEN}║${ARROW} ${GREEN}[1] Clean System Cache   ║${ARROW} ${YELLOW}[11] Alireza0 3X-UI     ${NC}"
    echo -e "${GREEN}║${ARROW} ${GREEN}[2] Check Disk Space     ║${ARROW} ${YELLOW}[12] Install ZI-VPN     ${NC}"
    echo -e "${GREEN}║                           ║${ARROW} ${YELLOW}[13] Uninstall ZI-VPN   ${NC}"
    echo -e "${GREEN}╚═════════════════════════════════════════════════════════╝${NC}\n"
    
    # Speed Optimization and SSH Managers (side by side)
    echo -e "${CYAN}╔═════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   ${WHITE}Speed Optimization${CYAN}      ║   ${WHITE}SSH Managers                 ${NC}"
    echo -e "${CYAN}╠═════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║${ARROW} ${CYAN}[20] 404 UDP Boost       ║${ARROW} ${BLUE}[30] DARKSSH Manager    ${NC}"
    echo -e "${CYAN}║${ARROW} ${CYAN}[21] UDP Custom Manager  ║${ARROW} ${BLUE}[31] 404-SSH Manager    ${NC}"
    echo -e "${CYAN}╚═════════════════════════════════════════════════════════╝${NC}\n"
    
    # Tools and Other Options (side by side)
    echo -e "${PURPLE}╔═════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║   ${WHITE}Tools${PURPLE}                   ║   ${WHITE}Other Options            ${NC}"
    echo -e "${PURPLE}╠═════════════════════════════════════════════════════════╣${NC}"
    echo -e "${PURPLE}║${ARROW} ${PURPLE}[40] Selector Tool       ║${ARROW} ${RED}help Show Help       ${NC}"
    echo -e "${PURPLE}║${ARROW} ${PURPLE}[41] Server Benchmark    ║${ARROW} ${RED}exit Quit Program    ${NC}"
    echo -e "${PURPLE}╚═════════════════════════════════════════════════════════╝${NC}"
}

## ---------------------------
## Installation Functions
## ---------------------------

system_update() {
    draw_box "System Update & Upgrade" $GREEN 60 "Performing system update..."
    apt update && apt upgrade -y
    draw_box "System Update Complete" $GREEN 60 "System updated successfully!"
}

clean_cache() {
    draw_box "Clean System Cache" $GREEN 60 "Cleaning system cache..."
    apt clean && apt autoclean
    draw_box "Cache Cleaned" $GREEN 60 "System cache cleaned!"
}

check_disk() {
    draw_box "Disk Space Check" $GREEN 60 "Checking disk space..."
    df -h
}

install_mhsanaei() {
    draw_box "Installing MHSanaei 3X-UI" $YELLOW 60 "This may take a few minutes..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
}

install_alireza() {
    draw_box "Installing Alireza0 3X-UI" $YELLOW 60 "This may take a few minutes..."
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
}

install_zivpn() {
    draw_box "Installing ZI-VPN" $YELLOW 60 "This may take a few minutes..."
    wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
    chmod +x zi.sh
    ./zi.sh
}

uninstall_zivpn() {
    draw_box "Uninstalling ZI-VPN" $YELLOW 60 "Removing ZI-VPN..."
    wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
    chmod +x ziun.sh
    ./ziun.sh
}

install_404udp() {
    draw_box "Installing 4-0-4 UDP Script" $CYAN 60 "This may take a few minutes..."
    git clone https://github.com/nyeinkokoaung404/udp-custom
    cd udp-custom || exit
    chmod +x install.sh
    ./install.sh
}

install_udpmanager() {
    draw_box "Installing UDP Custom Manager" $CYAN 60 "This may take a few minutes..."
    wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
    chmod +x install.sh
    bash install.sh
}

install_darkssh() {
    draw_box "Installing DARKSSH Manager" $BLUE 60 "This may take a few minutes..."
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
    chmod 777 Dark
    ./Dark
}

install_404ssh() {
    draw_box "Installing 404-SSH Manager" $BLUE 60 "This may take a few minutes..."
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
    chmod 777 hehe
    ./hehe
}

install_selector() {
    draw_box "Installing Selector Tool" $PURPLE 60 "This may take a few minutes..."
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    draw_box "Installation Complete" $PURPLE 60 "You can now run the tool with '404' command."
}

run_benchmark() {
    draw_box "Running Server Benchmark" $PURPLE 60 "This may take several minutes..."
    curl -sL yabs.sh | bash
}

show_help() {
    draw_box "HELP INFORMATION" $CYAN 60 "\
${ARROW} ${GREEN}This tool provides quick installation of server utilities.${NC}\n\
${ARROW} ${YELLOW}Each option will download and install software automatically.${NC}\n\
${ARROW} ${RED}Ensure you have proper permissions before installations.${NC}\n\n\
${STAR} ${BLUE}Key Features:${NC}\n\
  ${DIAMOND} System Maintenance Tools\n\
  ${DIAMOND} VPN Xray Panel Installations\n\
  ${DIAMOND} Network Speed Optimization\n\
  ${DIAMOND} SSH Management Utilities"
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
            echo -e "${STAR} ${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            ;;
        exit)
            draw_box "Goodbye" $GREEN 60 "Thank you for using the Server Management Toolkit!"
            echo -e "\n"
            exit 0
            ;;
        *)
            if [[ "$user_input" =~ ^[0-9]+$ ]]; then
                install_option "$user_input"
                echo -e "${STAR} ${YELLOW}Press any key to return to the menu...${NC}"
                read -n 1 -s -r
            else
                draw_box "Invalid Input" $RED 60 "Please enter a valid option!"
                echo -e "${STAR} ${YELLOW}Press any key to continue...${NC}"
                read -n 1 -s -r
            fi
            ;;
    esac
done
