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
NC='\033[0m' # No Color

# UI Elements
ARROW="${CYAN}➜${NC}"
STAR="${YELLOW}✰${NC}"

# Script Info
SCRIPT_VERSION="2.2"
DEVELOPER="404"
CONTACT="t.me/nkka404"
SCRIPT_URL="https://raw.githubusercontent.com/yourrepo/yourscript/main/script.sh" # You might want to update this URL if you host it elsewhere

## ---------------------------
## Display Functions
## ---------------------------

# Calculates padding for centering text
calculate_padding() {
    local text_length=$1
    local terminal_width=$(tput cols)
    local padding=$(( (terminal_width - text_length) / 2 ))
    [ $padding -lt 0 ] && padding=0 # Ensure padding is not negative
    printf "%${padding}s"
}

# Centers text on the console
center_text() {
    local text="$1"
    local color="$2"
    
    # Remove color codes for accurate length calculation
    local clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local text_length=${#clean_text}
    
    printf "%s${color}%s${NC}\n" "$(calculate_padding $text_length)" "$text"
}

# Draws a line within a box format
draw_box_line() {
    local text="$1"
    local box_color="$2"
    local text_color="$3"
    
    # Calculate available space (2 characters less for borders)
    local terminal_width=$(tput cols)
    local max_length=$((terminal_width - 2))
    local clean_text=$(echo -e "$text" | sed 's/\x1b\[[0-9;]*m//g')
    local text_length=${#clean_text}
    
    # Truncate text if it's too long
    if [ $text_length -gt $max_length ]; then
        text="${text:0:$max_length}"
        clean_text="${clean_text:0:$max_length}"
        text_length=$max_length
    fi
    
    local padding_left=$(( (max_length - text_length) / 2 ))
    local padding_right=$(( max_length - text_length - padding_left ))
    
    printf "${box_color}║${NC}%${padding_left}s${text_color}%s${NC}%${padding_right}s${box_color}║${NC}\n" "" "$text" ""
}

# Displays the script header
show_header() {
    clear
    center_text "╔════════════════════════════════════════╗" $PURPLE
    center_text "║      Server Management Toolkit        ║" $PURPLE
    center_text "╚════════════════════════════════════════╝" $PURPLE
    center_text "Developed by $DEVELOPER | Version $SCRIPT_VERSION" $CYAN
    center_text "Contact: $CONTACT" $CYAN
    echo
}

# Displays system information in a formatted box
show_system_info() {
    center_text "╔════════════════════════════════════════╗" $GREEN
    draw_box_line "          System Information          " $GREEN $WHITE
    center_text "╠════════════════════════════════════════╣" $GREEN
    
    draw_box_line " ${STAR} ${GREEN}Hostname:${NC} $(hostname)" $GREEN $WHITE
    draw_box_line " ${STAR} ${GREEN}IP:${NC} $(hostname -I | awk '{print $1}')" $GREEN $WHITE
    draw_box_line " ${STAR} ${GREEN}Uptime:${NC} $(uptime -p)" $GREEN $WHITE
    draw_box_line " ${STAR} ${GREEN}OS:${NC} $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)" $GREEN $WHITE
    draw_box_line " ${STAR} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)" $GREEN $WHITE
    draw_box_line " ${STAR} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}')" $GREEN $WHITE
    draw_box_line " ${STAR} ${GREEN}Disk:${NC} $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')" $GREEN $WHITE
    
    center_text "╚════════════════════════════════════════╝" $GREEN
}

# Displays the main menu options
show_menu() {
    show_header
    show_system_info
    
    center_text "╔════════════════════════════════════════╗" $GREEN
    draw_box_line "      Server Management Menu       " $GREEN $WHITE
    center_text "╠══════════════════════╦═══════════════════╣" $GREEN
    
    draw_box_line " ${CYAN}[0]${NC} System Update    ║ ${YELLOW}[10]${NC} MHSanaei 3X-UI " $GREEN $WHITE
    draw_box_line " ${CYAN}[1]${NC} Clean Cache      ║ ${YELLOW}[11]${NC} Alireza0 3X-UI " $GREEN $WHITE
    draw_box_line " ${CYAN}[2]${NC} Check Disk       ║ ${YELLOW}[12]${NC} Install ZI-VPN " $GREEN $WHITE
    draw_box_line " ${CYAN}[3]${NC} Update Script    ║ ${YELLOW}[13]${NC} Remove ZI-VPN  " $GREEN $WHITE
    center_text "╠══════════════════════╩═══════════════════╣" $GREEN
    
    draw_box_line " ${BLUE}[20]${NC} 404 UDP Boost    ║ ${PURPLE}[30]${NC} DARKSSH        " $GREEN $WHITE
    draw_box_line " ${BLUE}[21]${NC} UDP Manager      ║ ${PURPLE}[31]${NC} 404-SSH        " $GREEN $WHITE
    center_text "╠══════════════════════╦═══════════════════╣" $GREEN
    
    draw_box_line " ${PURPLE}[40]${NC} Selector         ║ ${RED}[50]${NC} Install RDP    " $GREEN $WHITE
    draw_box_line " ${PURPLE}[41]${NC} Benchmark        ║ ${RED}help${NC} Show Help      " $GREEN $WHITE
    draw_box_line "                      ║ ${RED}exit${NC} Quit          " $GREEN $WHITE
    
    center_text "╚══════════════════════╩═══════════════════╝" $GREEN
}

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
    local dependencies=("figlet" "screen" "git") # Added 'git' as a common dependency for many install functions
    for dep in "${dependencies[@]}"; do
        if ! command -v $dep &> /dev/null; then
            echo -e "${YELLOW}Installing $dep...${NC}"
            apt-get update -qq >/dev/null && apt-get install -y -qq $dep >/dev/null
            if [ $? -ne 0 ]; then
                echo -e "${RED}Failed to install $dep. Please install it manually.${NC}"
                exit 1
            fi
        fi
    done
}
check_dependencies

## ---------------------------
## Core Functions
## ---------------------------

# Updates system packages
system_update() {
    echo -e "${YELLOW}Updating system packages...${NC}"
    apt update -y && apt upgrade -y
    echo -e "${GREEN}System update completed!${NC}"
}

# Cleans system cache
clean_cache() {
    echo -e "${YELLOW}Cleaning system cache...${NC}"
    apt clean && apt autoclean
    echo -e "${GREEN}Cache cleaned successfully!${NC}"
}

# Checks disk space usage
check_disk() {
    echo -e "${YELLOW}Disk space usage:${NC}"
    df -h
}

# Installs MHSanaei 3X-UI
install_mhsanaei() {
    echo -e "${YELLOW}Installing MHSanaei 3X-UI...${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo -e "${GREEN}MHSanaei 3X-UI installation script executed.${NC}"
}

# Installs Alireza0 3X-UI
install_alireza() {
    echo -e "${YELLOW}Installing Alireza0 3X-UI...${NC}"
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
    echo -e "${GREEN}Alireza0 3X-UI installation script executed.${NC}"
}

# Installs ZI-VPN
install_zivpn() {
    echo -e "${YELLOW}Installing ZI-VPN...${NC}"
    wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
    chmod +x zi.sh
    ./zi.sh
    echo -e "${GREEN}ZI-VPN installation script executed.${NC}"
}

# Uninstalls ZI-VPN
uninstall_zivpn() {
    echo -e "${YELLOW}Uninstalling ZI-VPN...${NC}"
    wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
    chmod +x ziun.sh
    ./ziun.sh
    echo -e "${GREEN}ZI-VPN uninstallation script executed.${NC}"
}

# Installs 404 UDP Boost
install_404udp() {
    echo -e "${YELLOW}Installing 404 UDP Boost...${NC}"
    if [ -d "udp-custom" ]; then
        echo -e "${YELLOW}udp-custom directory already exists. Skipping clone and proceeding to install.${NC}"
        cd udp-custom || return
    else
        git clone https://github.com/nyeinkokoaung404/udp-custom
        cd udp-custom || return
    fi
    chmod +x install.sh
    ./install.sh
    cd .. # Go back to the original directory
    echo -e "${GREEN}404 UDP Boost installation script executed.${NC}"
}

# Installs UDP Custom Manager
install_udpmanager() {
    echo -e "${YELLOW}Installing UDP Custom Manager...${NC}"
    wget https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh -O install.sh
    chmod +x install.sh
    bash install.sh
    echo -e "${GREEN}UDP Custom Manager installation script executed.${NC}"
}

# Installs DARKSSH Manager
install_darkssh() {
    echo -e "${YELLOW}Installing DARKSSH Manager...${NC}"
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark -O Dark
    chmod 777 Dark
    ./Dark
    echo -e "${GREEN}DARKSSH Manager installation script executed.${NC}"
}

# Installs 404-SSH Manager
install_404ssh() {
    echo -e "${YELLOW}Installing 404-SSH Manager...${NC}"
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe -O hehe
    chmod 777 hehe
    ./hehe
    echo -e "${GREEN}404-SSH Manager installation script executed.${NC}"
}

# Installs Selector Tool
install_selector() {
    echo -e "${YELLOW}Installing Selector Tool...${NC}"
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    echo -e "${GREEN}Selector Tool installation script executed.${NC}"
}

# Runs server benchmark
run_benchmark() {
    echo -e "${YELLOW}Running server benchmark...${NC}"
    curl -sL yabs.sh | bash
    echo -e "${GREEN}Benchmark script executed. Review output above.${NC}"
}

# Installs RDP service in a screen session
install_rdp() {
    echo -e "${YELLOW}Installing RDP service...${NC}"
    screen -dmS rdp-installer bash -c '
        (wget https://tinyinstaller.top/setup.sh -4O tinyinstaller.sh || curl https://tinyinstaller.top/setup.sh -Lo tinyinstaller.sh) && bash tinyinstaller.sh free
        echo "RDP installation script finished."
    '
    echo -e "${GREEN}RDP installation started in background screen session.${NC}"
    echo -e "Use ${CYAN}screen -r rdp-installer${NC} to view progress."
}

# Updates the script itself
update_script() {
    echo -e "${YELLOW}Checking for updates...${NC}"
    # Fetch the latest version directly without executing the script
    latest_version=$(curl -s $SCRIPT_URL | grep "SCRIPT_VERSION=" | head -n 1 | cut -d'"' -f2)
    
    if [ -z "$latest_version" ]; then
        echo -e "${RED}Could not fetch latest version from $SCRIPT_URL. Please check the URL or your network connection.${NC}"
        return 1
    fi

    if [ "$latest_version" != "$SCRIPT_VERSION" ]; then
        echo -e "${GREEN}New version available: $latest_version (Current: $SCRIPT_VERSION)${NC}"
        echo -e "${YELLOW}Updating...${NC}"
        if wget -O "$0" "$SCRIPT_URL"; then
            echo -e "${GREEN}Update complete! Restarting script...${NC}"
            exec "$0"
        else
            echo -e "${RED}Failed to download the updated script. Please try again or update manually.${NC}"
        fi
    else
        echo -e "${GREEN}You have the latest version ($SCRIPT_VERSION)${NC}"
    fi
}

# Displays help information
show_help() {
    center_text "╔════════════════════════════════════════╗" $GREEN
    draw_box_line "            Help Information            " $GREEN $WHITE
    center_text "╠════════════════════════════════════════╣" $GREEN
    draw_box_line " ${ARROW} Enter option number to execute command" $GREEN $WHITE
    draw_box_line " ${ARROW} Type ${CYAN}help${NC} to show this message" $GREEN $WHITE
    draw_box_line " ${ARROW} Type ${CYAN}exit${NC} to quit the program" $GREEN $WHITE
    draw_box_line " " $GREEN $WHITE
    draw_box_line " ${GREEN}System Management:${NC} 0-3" $GREEN $WHITE
    draw_box_line " ${YELLOW}VPN Panels:${NC} 10-13" $GREEN $WHITE
    draw_box_line " ${CYAN}Speed Tools:${NC} 20-21" $GREEN $WHITE
    draw_box_line " ${BLUE}SSH Managers:${NC} 30-31" $GREEN $WHITE
    draw_box_line " ${PURPLE}Other Tools:${NC} 40-41, 50" $GREEN $WHITE
    center_text "╚════════════════════════════════════════╝" $GREEN
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
            echo -e "${RED}Invalid option! Please enter a valid number or command.${NC}"
            ;;
    esac
    
    echo -e "${YELLOW}Press any key to continue...${NC}"
    read -n 1 -s -r
done
