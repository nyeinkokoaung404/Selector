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

# Box Drawing Characters
BOX_HORIZ="━"
BOX_VERT="┃"
BOX_CORNER_TL="┏"
BOX_CORNER_TR="┓"
BOX_CORNER_BL="┗"
BOX_CORNER_BR="┛"

## ---------------------------
## Initial Checks
## ---------------------------

# Root check
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root!${NC}"
    exit 1
fi

## ---------------------------
## Display Functions
## ---------------------------

# Function to get system information
get_system_info() {
    OS=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    UPTIME=$(uptime -p | sed 's/up //')
    IPV4=$(hostname -I | awk '{print $1}')
    DOMAIN=${IPV4}
}

# Function to draw box with title and content
draw_box() {
    local width=56
    local title="$1"
    local color="$2"
    local content="$3"
    
    # Top border with title
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"
    
    # Title centered
    local title_len=${#title}
    local padding_left=$(( (width - title_len - 2) / 2 ))
    local padding_right=$(( width - title_len - padding_left - 2 ))
    
    echo -ne "${color}${BOX_VERT}"
    printf "%${padding_left}s" ""
    echo -ne "${WHITE}${title}"
    printf "%${padding_right}s" ""
    echo -e "${color}${BOX_VERT}${NC}"
    
    # Content
    while IFS= read -r line; do
        if [ -n "$line" ]; then
            echo -e "${color}${BOX_VERT}${NC} ${line}${color}${NC}"
        else
            echo -e "${color}${BOX_VERT}${NC}"
        fi
    done <<< "$content"
    
    # Bottom border
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

# Function to draw simple box
draw_simple_box() {
    local width=56
    local content="$1"
    local color="$2"
    
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"
    
    while IFS= read -r line; do
        echo -e "${color}${BOX_VERT}${NC} ${line}${color}${NC}"
    done <<< "$content"
    
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

## ---------------------------
## Working Installation Functions
## ---------------------------

system_update() {
    draw_simple_box "${GREEN}Performing system update...${NC}" $GREEN
    apt update && apt upgrade -y
    apt autoremove -y
    draw_simple_box "${GREEN}System updated successfully!${NC}" $GREEN
}

clean_cache() {
    draw_simple_box "${GREEN}Cleaning system cache...${NC}" $GREEN
    apt clean
    apt autoclean
    sync
    draw_simple_box "${GREEN}System cache cleaned!${NC}" $GREEN
}

check_disk() {
    draw_simple_box "${GREEN}Checking disk space...${NC}" $GREEN
    df -h
    echo -e "\n${YELLOW}Large directories:${NC}"
    du -sh /var/log/* 2>/dev/null | sort -hr | head -10
}

install_mhsanaei() {
    draw_simple_box "${YELLOW}Installing MHSanaei 3X-UI...${NC}" $YELLOW
    if command -v curl &> /dev/null; then
        bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    else
        apt install curl -y
        bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    fi
}

install_alireza() {
    draw_simple_box "${YELLOW}Installing Alireza0 3X-UI...${NC}" $YELLOW
    if command -v curl &> /dev/null; then
        bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
    else
        apt install curl -y
        bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
    fi
}

install_zivpn() {
    draw_simple_box "${YELLOW}Installing ZI-VPN...${NC}" $YELLOW
    if command -v wget &> /dev/null; then
        wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
        chmod +x zi.sh
        ./zi.sh
    else
        apt install wget -y
        wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
        chmod +x zi.sh
        ./zi.sh
    fi
}

uninstall_zivpn() {
    draw_simple_box "${YELLOW}Uninstalling ZI-VPN...${NC}" $YELLOW
    if command -v wget &> /dev/null; then
        wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
        chmod +x ziun.sh
        ./ziun.sh
    else
        apt install wget -y
        wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
        chmod +x ziun.sh
        ./ziun.sh
    fi
}

install_404udp() {
    draw_simple_box "${CYAN}Installing 4-0-4 UDP Script...${NC}" $CYAN
    if command -v git &> /dev/null; then
        git clone https://github.com/nyeinkokoaung404/udp-custom
        cd udp-custom && chmod +x install.sh && ./install.sh
    else
        apt install git -y
        git clone https://github.com/nyeinkokoaung404/udp-custom
        cd udp-custom && chmod +x install.sh && ./install.sh
    fi
}

install_udpmanager() {
    draw_simple_box "${CYAN}Installing UDP Custom Manager...${NC}" $CYAN
    if command -v wget &> /dev/null; then
        wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
        chmod +x install.sh
        bash install.sh
    else
        apt install wget -y
        wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
        chmod +x install.sh
        bash install.sh
    fi
}

install_darkssh() {
    draw_simple_box "${BLUE}Installing DARKSSH Manager...${NC}" $BLUE
    if command -v wget &> /dev/null; then
        wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
        chmod +x Dark
        ./Dark
    else
        apt install wget -y
        wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
        chmod +x Dark
        ./Dark
    fi
}

install_404ssh() {
    draw_simple_box "${BLUE}Installing 404-SSH Manager...${NC}" $BLUE
    if command -v wget &> /dev/null; then
        wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
        chmod +x hehe
        ./hehe
    else
        apt install wget -y
        wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
        chmod +x hehe
        ./hehe
    fi
}

install_rdp() {
    draw_simple_box "${PURPLE}Installing RDP...${NC}" $PURPLE
    (wget https://free.tiurl.top/setup.sh -4O tinyinstaller.sh || curl https://free.tiurl.top/setup.sh -Lo tinyinstaller.sh) && bash tinyinstaller.sh free
}

install_dotytunnel() {
    draw_simple_box "${CYAN}Installing DOTY TUNNEL...${NC}" $CYAN
    wget -O /root/doty.sh https://raw.githubusercontent.com/dotywrt/doty/main/doty.sh
    chmod +x /root/doty.sh
    /root/doty.sh
}

install_selector() {
    draw_simple_box "${PURPLE}Installing Selector Tool...${NC}" $PURPLE
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    draw_simple_box "${PURPLE}You can now run the tool with '404' command.${NC}" $PURPLE
}

run_benchmark() {
    draw_simple_box "${PURPLE}Running Server Benchmark...${NC}" $PURPLE
    curl -sL yabs.sh | bash
}

reboot_vps() {
    draw_simple_box "${RED}Rebooting VPS...${NC}" $RED
    echo -e "${YELLOW}VPS will reboot in 5 seconds...${NC}"
    sleep 5
    reboot
}

check_vps_status() {
    draw_simple_box "${GREEN}Checking VPS Status...${NC}" $GREEN
    echo -e "${WHITE}CPU Usage:${NC} $(top -bn1 | grep "Cpu(s)" | awk '{print $2}')%"
    echo -e "${WHITE}Memory Usage:${NC} $(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')"
    echo -e "${WHITE}Disk Usage:${NC} $(df -h / | awk 'NR==2{print $5}')"
    echo -e "${WHITE}Uptime:${NC} $(uptime -p)"
    echo -e "${WHITE}Load Average:${NC} $(uptime | awk -F'load average:' '{print $2}')"
}

clean_vps_logs() {
    draw_simple_box "${YELLOW}Cleaning VPS Logs...${NC}" $YELLOW
    echo -e "${WHITE}Clearing system logs...${NC}"
    truncate -s 0 /var/log/syslog
    truncate -s 0 /var/log/auth.log
    truncate -s 0 /var/log/kern.log
    echo -e "${WHITE}Clearing journal logs...${NC}"
    journalctl --vacuum-time=1d
    echo -e "${WHITE}Clearing temporary files...${NC}"
    rm -rf /tmp/*
    rm -rf /var/tmp/*
    draw_simple_box "${GREEN}VPS logs cleaned successfully!${NC}" $GREEN
}

show_vpn_port_info() {
    draw_simple_box "${BLUE}VPN Port Information...${NC}" $BLUE
    echo -e "${WHITE}Active listening ports:${NC}"
    netstat -tulpn | grep LISTEN
    echo -e "\n${WHITE}Common VPN ports status:${NC}"
    for port in 80 443 8080 8443 22 53; do
        if netstat -tulpn | grep ":${port} " > /dev/null; then
            echo -e "Port ${port}: ${GREEN}OPEN${NC}"
        else
            echo -e "Port ${port}: ${RED}CLOSED${NC}"
        fi
    done
}

## ---------------------------
## Menu Display
## ---------------------------

display_header() {
    clear
    get_system_info
    
    # Main header
    draw_box "CHANNEL 404 TUNNEL" $CYAN ""
    
    # System info box
    local sysinfo=$(cat <<EOF
${WHITE} OS         : ${GREEN}${OS}${NC}
${WHITE} UPTIME     : ${GREEN}${UPTIME}${NC}
${WHITE} IPv4       : ${GREEN}${IPV4}${NC}
${WHITE} DOMAIN     : ${GREEN}${DOMAIN}${NC}
EOF
)
    draw_simple_box "$sysinfo" $BLUE
    
    # Main menu - Updated with new options
    local mainmenu=$(cat <<EOF

${WHITE}[01] • 404-SSH Manager     [07] • DARK SSH MANAGER${NC}
${WHITE}[02] • MHSanaei 3X-UI      [08] • ZI-VPN UNINSTALL${NC}
${WHITE}[03] • Alireza0 3X-UI      [09] • RDP INSTALLER${NC}
${WHITE}[04] • 404 UDP Boost       [10] • DOTY TUNNEL${NC}
${WHITE}[05] • UDP Manager         [11] • Selector Tool${NC}
${WHITE}[06] • ZI-VPN Install${NC}
EOF
)
    draw_box "MENU" $GREEN "$mainmenu"
    
    # Tools menu
    local toolsmenu=$(cat <<EOF

${WHITE}[12] • System Update       [16] • Server Benchmark${NC}
${WHITE}[13] • Clean Cache         [17] • VPN Port Info${NC}
${WHITE}[14] • Check Disk Space    [18] • Clean VPS Logs${NC}
${WHITE}[15] • VPS Status${NC}

${WHITE}[00] • EXIT               [88] • REBOOT VPS${NC}
EOF
)
    draw_box "TOOLS" $PURPLE "$toolsmenu"
    
    # Footer
    local footer=$(cat <<EOF
${WHITE}• VERSION      : 2.1${NC}
${WHITE}• SCRIPT BY    : CHANNEL 404 TEAM${NC}
${WHITE}• CONTACT OWNER  : t.me/nkka404${NC}
EOF
)
    draw_simple_box "$footer" $YELLOW
    
    # Bottom separator
    echo -e "${CYAN}●━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━●${NC}"
}

## ---------------------------
## Menu Handlers
## ---------------------------

handle_main_menu() {
    case $1 in
        01) install_404ssh ;;
        02) install_mhsanaei ;;
        03) install_alireza ;;
        04) install_404udp ;;
        05) install_udpmanager ;;
        06) install_zivpn ;;
        07) install_darkssh ;;
        08) uninstall_zivpn ;;
        09) install_rdp ;;
        10) install_dotytunnel ;;
        11) install_selector ;;
        *) return 1 ;;
    esac
    return 0
}

handle_tools_menu() {
    case $1 in
        12) system_update ;;
        13) clean_cache ;;
        14) check_disk ;;
        15) check_vps_status ;;
        16) run_benchmark ;;
        17) show_vpn_port_info ;;
        18) clean_vps_logs ;;
        88) reboot_vps ;;
        *) return 1 ;;
    esac
    return 0
}

install_option() {
    case $1 in
        00) return 0 ;;
        01|02|03|04|05|06|07|08|09|10|11) handle_main_menu "$1" ;;
        12|13|14|15|16|17|18|88) handle_tools_menu "$1" ;;
        *) draw_simple_box "${RED}Invalid Option!${NC}" $RED ;;
    esac
}

## ---------------------------
## Main Program
## ---------------------------

while true; do
    display_header
    
    echo -en "${GREEN} Select menu : ${NC}"
    read -r user_input
    
    case $user_input in
        exit|00)
            draw_simple_box "${GREEN}Thank you for using CHANNEL 404 TUNNEL!${NC}" $GREEN
            echo -e "\n"
            exit 0
            ;;
        *)
            if [[ "$user_input" =~ ^[0-9]+$ ]]; then
                if [ "$user_input" -eq 0 ]; then
                    draw_simple_box "${GREEN}Thank you for using CHANNEL 404 TUNNEL!${NC}" $GREEN
                    echo -e "\n"
                    exit 0
                fi
                install_option "$user_input"
                echo -e "\n${YELLOW}Press any key to continue...${NC}"
                read -n 1 -s -r
            else
                draw_simple_box "${RED}Please enter a valid option number!${NC}" $RED
                echo -e "\n${YELLOW}Press any key to continue...${NC}"
                read -n 1 -s -r
            fi
            ;;
    esac
done
