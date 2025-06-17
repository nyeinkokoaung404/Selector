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
## Initial Checks
## ---------------------------

# Root check
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root!${NC}"
    exit 1
fi

# Check and install figlet if not exists
if ! command -v figlet &> /dev/null; then
    echo -e "${YELLOW}Installing figlet for better display...${NC}"
    apt-get update && apt-get install -y figlet
fi

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

# Box drawing function
draw_box() {
    local title="$1"
    local color="$2"
    local width="$3"
    local content="$4"
    
    local padding=$(( (width - ${#title} - 2) / 2 ))
    local title_line=$(printf "%${padding}s %s %${padding}s" "" "$title" "")
    title_line=${title_line:0:$width}  # Ensure it doesn't exceed width
    
    echo -e "${color}┌$(printf '%*s' $((width-2)) | tr ' ' '─')┐${NC}"
    echo -e "${color}│${title_line}│${NC}"
    echo -e "${color}├$(printf '%*s' $((width-2)) | tr ' ' '─')┤${NC}"
    
    # Handle multi-line content
    while IFS= read -r line; do
        printf "${color}│ ${NC}%-$((width-3))s ${color}│${NC}\n" "$line"
    done <<< "$content"
    
    echo -e "${color}└$(printf '%*s' $((width-2)) | tr ' ' '─')┘${NC}"
}

# Display system information
show_system_info() {
    echo -e "${DOUBLE_LINE}"
    draw_box "System Information" $GREEN 60 "\
${STAR} ${GREEN}Hostname:${NC} $(hostname)\n\
${STAR} ${GREEN}IP Address:${NC} $IP_ADDRESS\n\
${STAR} ${GREEN}Uptime:${NC} $UPTIME\n\
${STAR} ${GREEN}OS:${NC} $OS_INFO\n\
${STAR} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)\n\
${STAR} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}')"
    echo -e "${DOUBLE_LINE}"
}

# Beautiful header with ASCII art
display_header() {
    clear
    
    # Display 404 with figlet
    echo -e "${RED}"
    figlet -f slant "4 0 4" | awk -v termwidth="$(tput cols)" '
    {
        spaces = int((termwidth - 70) / 2)
        printf "%" spaces "s%s\n", "", $0
    }'
    echo -e "${NC}"
    
    center "Server Management Toolkit v2.0" $PURPLE "═"
}

# Beautiful menu with categories
show_menu() {
    echo -e "\n${WHITE}╒══════════════════════════════════════════════════════════════════════════════╕${NC}"
    echo -e "${WHITE}│${NC} ${PURPLE}MAIN MENU - Please select an option:${NC} ${WHITE}│${NC}"
    echo -e "${WHITE}╞══════════════════════════════════════════════════════════════════════════════╡${NC}"
    
    # System Management
    draw_box "System Management" $GREEN 60 "\
${ARROW} ${GREEN}[0]${NC} ◇ System Update & Upgrade\n\
${ARROW} ${GREEN}[1]${NC} ◇ Clean System Cache\n\
${ARROW} ${GREEN}[2]${NC} ◇ Check Disk Space"
    
    # VPN Panels
    draw_box "VPN Panels" $YELLOW 60 "\
${ARROW} ${YELLOW}[10]${NC} ◇ Install MHSanaei 3X-UI\n\
${ARROW} ${YELLOW}[11]${NC} ◇ Install Alireza0 3X-UI\n\
${ARROW} ${YELLOW}[12]${NC} ◇ Install ZI-VPN\n\
${ARROW} ${YELLOW}[13]${NC} ◇ Uninstall ZI-VPN"
    
    # Speed Optimization
    draw_box "Speed Optimization" $CYAN 60 "\
${ARROW} ${CYAN}[20]${NC} ◇ Install 4-0-4 UDP Boost\n\
${ARROW} ${CYAN}[21]${NC} ◇ Install UDP Custom Manager"
    
    # SSH Managers
    draw_box "SSH Managers" $BLUE 60 "\
${ARROW} ${BLUE}[30]${NC} ◇ Install DARKSSH Manager\n\
${ARROW} ${BLUE}[31]${NC} ◇ Install 404-SSH Manager"
    
    # Tools
    draw_box "Tools" $PURPLE 60 "\
${ARROW} ${PURPLE}[40]${NC} ◇ Install Selector Tool\n\
${ARROW} ${PURPLE}[41]${NC} ◇ Server Benchmark"
    
    # Other
    draw_box "Other Options" $RED 60 "\
${ARROW} ${RED}help${NC} ◇ Show Help Information\n\
${ARROW} ${RED}exit${NC} ◇ Quit Program"
    
    echo -e "${WHITE}╘══════════════════════════════════════════════════════════════════════════════╛${NC}"
}

# Installation Functions
install_option() {
    case $1 in
        0)
            draw_box "System Update & Upgrade" $GREEN 60 "Performing system update..."
            apt update && apt upgrade -y
            draw_box "System Update Complete" $GREEN 60 "System updated successfully!"
            ;;
        1)
            draw_box "Clean System Cache" $GREEN 60 "Cleaning system cache..."
            apt clean && apt autoclean
            draw_box "Cache Cleaned" $GREEN 60 "System cache cleaned!"
            ;;
        2)
            draw_box "Disk Space Check" $GREEN 60 "Checking disk space..."
            df -h
            ;;
        10)
            draw_box "Installing MHSanaei 3X-UI" $YELLOW 60 "This may take a few minutes..."
            bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
            ;;
        11)
            draw_box "Installing Alireza0 3X-UI" $YELLOW 60 "This may take a few minutes..."
            bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
            ;;
        12)
            draw_box "Installing ZI-VPN" $YELLOW 60 "This may take a few minutes..."
            wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
            chmod +x zi.sh
            ./zi.sh
            ;;
        13)
            draw_box "Uninstalling ZI-VPN" $YELLOW 60 "Removing ZI-VPN..."
            wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
            chmod +x ziun.sh
            ./ziun.sh
            ;;
        20)
            draw_box "Installing 4-0-4 UDP Script" $CYAN 60 "This may take a few minutes..."
            git clone https://github.com/nyeinkokoaung404/udp-custom
            cd udp-custom || exit
            chmod +x install.sh
            ./install.sh
            ;;
        21)
            draw_box "Installing UDP Custom Manager" $CYAN 60 "This may take a few minutes..."
            wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
            chmod +x install.sh
            bash install.sh
            ;;
        30)
            draw_box "Installing DARKSSH Manager" $BLUE 60 "This may take a few minutes..."
            wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
            chmod 777 Dark
            ./Dark
            ;;
        31)
            draw_box "Installing 404-SSH Manager" $BLUE 60 "This may take a few minutes..."
            wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
            chmod 777 hehe
            ./hehe
            ;;
        40)
            draw_box "Installing Selector Tool" $PURPLE 60 "This may take a few minutes..."
            bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
            draw_box "Installation Complete" $PURPLE 60 "You can now run the tool with '404' command."
            ;;
        41)
            draw_box "Running Server Benchmark" $PURPLE 60 "This may take several minutes..."
            curl -sL yabs.sh | bash
            ;;
        *)
            draw_box "Error" $RED 60 "Invalid option selected!"
            return 1
            ;;
    esac
    return 0
}

# Help Information
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
                echo -e "${LINE}"
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
