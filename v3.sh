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
CHECK="${GREEN}✔${NC}"
CROSS="${RED}✖${NC}"
ARROW="${CYAN}➜${NC}"
DOT="${YELLOW}•${NC}"

## ---------------------------
## Initial Checks
## ---------------------------

# Root check
if [ "$(id -u)" -ne 0 ]; then
    echo -e "\n${RED}✖ This script must be run as root!${NC}\n" >&2
    exit 1
fi

# Check dependencies
check_dependencies() {
    local missing=()
    for cmd in figlet; do
        if ! command -v $cmd &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${YELLOW}Installing missing dependencies...${NC}"
        apt-get update && apt-get install -y "${missing[@]}"
    fi
}
check_dependencies

## ---------------------------
## Display Functions
## ---------------------------

# Center text on screen
center_text() {
    local cols=$(tput cols)
    local text="$1"
    local color="$2"
    printf "%*s\n" $(( (${#text} + cols) / 2 )) "${color}${text}${NC}"
}

# Modern box with centered content
draw_modern_box() {
    local title="$1"
    local color="$2"
    local width=60
    local content="$3"
    
    # Calculate positions
    local title_len=${#title}
    local padding=$(( (width - title_len - 4) / 2 ))
    
    # Top border
    echo -e "${color}┌$(printf '%0.s─' $(seq 1 $((width-2))))┐${NC}"
    
    # Title
    echo -ne "${color}│${NC}"
    printf "%$((padding))s" ""
    echo -ne " ${title} "
    printf "%$((padding))s" ""
    [ $(( (title_len + padding*2 + 2) % 2 )) -ne 0 ] && printf " "
    echo -e "${color}│${NC}"
    
    # Separator
    echo -e "${color}├$(printf '%0.s─' $(seq 1 $((width-2))))┤${NC}"
    
    # Content
    while IFS= read -r line; do
        # Remove color codes for length calculation
        clean_line=$(echo -e "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        local line_len=${#clean_line}
        local content_pad=$(( (width - line_len - 4) / 2 ))
        
        echo -ne "${color}│${NC}"
        printf "%${content_pad}s" ""
        echo -ne "$line"
        printf "%${content_pad}s" ""
        [ $(( (line_len + content_pad*2) % 2 )) -ne 0 ] && printf " "
        echo -e "${color}│${NC}"
    done <<< "$content"
    
    # Bottom border
    echo -e "${color}└$(printf '%0.s─' $(seq 1 $((width-2))))┘${NC}"
}

# Display header with modern design
display_header() {
    clear
    
    # Modern ASCII art header
    echo -e "${BLUE}$(figlet -f slant -w $(tput cols) -c "Server Manager")${NC}"
    
    # Centered information
    center_text "Developed by 404" $PURPLE
    center_text "Version 2.0 | $(date +'%Y-%m-%d')" $YELLOW
    center_text "Contact: t.me/nkka404" $CYAN
    
    # Separator line
    echo -e "${BLUE}$(printf '%*s' $(tput cols) | tr ' ' '─')${NC}\n"
}

# System information display
show_system_info() {
    local sysinfo=$(cat <<EOF
${DOT} ${GREEN}Hostname:${NC} $(hostname)
${DOT} ${GREEN}IP Address:${NC} $(hostname -I | awk '{print $1}')
${DOT} ${GREEN}Uptime:${NC} $(uptime -p | sed 's/up //')
${DOT} ${GREEN}OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
${DOT} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)
${DOT} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}' | tr -d ' ')
${DOT} ${GREEN}Disk Usage:${NC} $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')
EOF
)
    draw_modern_box "System Information" $GREEN "$sysinfo"
}

## ---------------------------
## Modern Menu System
## ---------------------------

show_menu() {
    local menu_items=(
        "System Update and Upgrade"
        "Clean System Cache"
        "Check Disk Space"
        "Install MHSanaei 3X-UI"
        "Install Alireza0 3X-UI"
        "Install ZI-VPN"
        "Uninstall ZI-VPN"
        "404 UDP Boost"
        "UDP Custom Manager"
        "DARKSSH Manager"
        "404-SSH Manager"
        "Selector Tool"
        "Server Benchmark"
    )
    
    echo -e "\n${WHITE}Main Menu:${NC}\n"
    
    for i in "${!menu_items[@]}"; do
        # Center each menu item
        printf "%s %2d) %s\n" "${DOT}" "$i" "${menu_items[$i]}" | 
        awk '{ len=(80-length($0))/2; printf "%*s%s\n", len, "", $0 }'
    done
    
    echo -e "\n${WHITE}Other Options:${NC}\n"
    center_text "help - Show help information" $YELLOW
    center_text "exit - Quit the program" $RED
}

## ---------------------------
## Installation Functions
## ---------------------------

system_update() {
    draw_modern_box "System Update" $GREEN "Updating package lists and upgrading installed packages..."
    apt update && apt upgrade -y
    draw_modern_box "Update Complete" $GREEN "System has been successfully updated!"
}

clean_cache() {
    draw_modern_box "Cleaning Cache" $BLUE "Removing unnecessary package files..."
    apt clean && apt autoclean
    draw_modern_box "Cache Cleaned" $BLUE "System cache has been cleaned!"
}

check_disk() {
    local disk_info=$(df -h)
    draw_modern_box "Disk Space Check" $YELLOW "$disk_info"
}

install_mhsanaei() {
    draw_modern_box "Installing MHSanaei 3X-UI" $PURPLE "Downloading and installing panel..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    draw_modern_box "Installation Complete" $PURPLE "MHSanaei 3X-UI has been installed!"
}

install_alireza() {
    draw_modern_box "Installing Alireza0 3X-UI" $PURPLE "Downloading and installing panel..."
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
    draw_modern_box "Installation Complete" $PURPLE "Alireza0 3X-UI has been installed!"
}

install_zivpn() {
    draw_modern_box "Installing ZI-VPN" $CYAN "Downloading installation script..."
    wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
    chmod +x zi.sh
    ./zi.sh
}

uninstall_zivpn() {
    draw_modern_box "Uninstalling ZI-VPN" $CYAN "Downloading uninstall script..."
    wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
    chmod +x ziun.sh
    ./ziun.sh
}

install_404udp() {
    draw_modern_box "Installing 404 UDP Boost" $BLUE "Cloning repository..."
    git clone https://github.com/nyeinkokoaung404/udp-custom
    cd udp-custom || exit
    chmod +x install.sh
    ./install.sh
}

install_udpmanager() {
    draw_modern_box "Installing UDP Manager" $BLUE "Downloading installation script..."
    wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
    chmod +x install.sh
    bash install.sh
}

install_darkssh() {
    draw_modern_box "Installing DARKSSH Manager" $PURPLE "Downloading manager..."
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
    chmod 777 Dark
    ./Dark
}

install_404ssh() {
    draw_modern_box "Installing 404-SSH Manager" $PURPLE "Downloading manager..."
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
    chmod 777 hehe
    ./hehe
}

install_selector() {
    draw_modern_box "Installing Selector Tool" $CYAN "Downloading and running installer..."
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    draw_modern_box "Installation Complete" $CYAN "Selector tool is now available!"
}

run_benchmark() {
    draw_modern_box "Running Benchmark" $YELLOW "This may take several minutes..."
    curl -sL yabs.sh | bash
}

show_help() {
    local help_text=$(cat <<EOF
${DOT} ${GREEN}This tool provides server management functions${NC}
${DOT} ${YELLOW}Select options by entering their numbers${NC}
${DOT} ${BLUE}All operations require root privileges${NC}
${DOT} ${PURPLE}Internet connection is required for installations${NC}
${DOT} ${CYAN}Contact developer for support: t.me/nkka404${NC}
EOF
)
    draw_modern_box "Help Information" $WHITE "$help_text"
}

## ---------------------------
## Main Program
## ---------------------------

main() {
    display_header
    show_system_info
    
    while true; do
        show_menu
        
        echo -e "\n"
        center_text "${ARROW} Enter your choice (0-12/help/exit): " $WHITE
        read -r user_input
        
        case $user_input in
            help)
                show_help
                ;;
            exit)
                draw_modern_box "Goodbye" $GREEN "Thank you for using Server Management Toolkit!"
                exit 0
                ;;
            [0-9]|1[0-2])
                case $user_input in
                    0) system_update ;;
                    1) clean_cache ;;
                    2) check_disk ;;
                    3) install_mhsanaei ;;
                    4) install_alireza ;;
                    5) install_zivpn ;;
                    6) uninstall_zivpn ;;
                    7) install_404udp ;;
                    8) install_udpmanager ;;
                    9) install_darkssh ;;
                    10) install_404ssh ;;
                    11) install_selector ;;
                    12) run_benchmark ;;
                esac
                ;;
            *)
                draw_modern_box "Invalid Input" $RED "Please enter a valid option number!"
                ;;
        esac
        
        echo -e "\n"
        center_text "${DOT} Press any key to continue..." $YELLOW
        read -n 1 -s -r
        display_header
    done
}

main
