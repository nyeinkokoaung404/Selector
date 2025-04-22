#!/bin/bash
clear

# Stylish Color Palette
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
NC='\033[0m'
BG='\033[44m'
FG_WHITE='\033[1;37m'

# Unicode Characters
CHECK="${GREEN}✓${NC}"
CROSS="${RED}✗${NC}"
ARROW="${CYAN}➜${NC}"
STAR="${YELLOW}★${NC}"
HEART="${RED}♥${NC}"

# Function to display centered text
center() {
    termwidth=$(tput cols)
    padding="$(printf '%0.1s' ={1..500})"
    printf "${BG}${FG_WHITE}%*.*s %s %*.*s${NC}\n" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

# Function to draw separator line
separator() {
    echo -e "${BLUE}$(printf '%*s' $(tput cols) | tr ' ' '═')${NC}"
}

# Header with Myanmar Unicode
# center "နည်းပညာ အထောက်အကူပြု Tools များ"
# echo ""
center "Server Management Panel"
#echo ""

# ASCII Art with Myanmar Text
echo -e "${YELLOW}"
cat << "EOF"
+------------------------------------------------------------------+
|     ___   ___          ________          ___   ___               |
|    |\  \ |\  \        |\   __  \        |\  \ |\  \              |
|    \ \  \|_\  \       \ \  \|\  \       \ \  \|_\  \             |
|     \ \______  \       \ \  \/\  \       \ \______  \            |
|      \|_____|\  \       \ \  \/\  \       \|_____|\  \           |
|             \ \__\       \ \_______\             \ \__\          |
|              \|__|        \|_______|              \|__|          |
+------------------------------------------------------------------+
EOF
echo -e "${NC}"

# System Info
separator
echo -e "${STAR} ${GREEN}Hostname:${NC} $(hostname)"
echo -e "${STAR} ${GREEN}IP Address:${NC} $(hostname -I | awk '{print $1}')"
echo -e "${STAR} ${GREEN}Uptime:${NC} $(uptime -p)"
separator

# Main Menu
echo -e "\n${MAGENTA}အဓိက Menu မှ ရွေးချယ်နိုင်ပါသည်${NC}\n"
echo -e "${ARROW} ${GREEN}0${NC} ◇ System Update & Upgrade လုပ်မည်"
echo -e "${ARROW} ${GREEN}1${NC} ◇ MHSanaei 3X-UI (Xray Panel)"
echo -e "${ARROW} ${GREEN}2${NC} ◇ Alireza0 3X-UI (Alternative Panel)"
echo -e "${ARROW} ${GREEN}3${NC} ◇ 4-0-4 UDP Script (Speed Boost)"
echo -e "${ARROW} ${GREEN}4${NC} ◇ UDP Custom Manager"
echo -e "${ARROW} ${GREEN}5${NC} ◇ DARKSSH Manager (SSH Panel)"
echo -e "${ARROW} ${GREEN}6${NC} ◇ 404-SSH Manager (Alternative SSH)"
echo -e "${ARROW} ${GREEN}7${NC} ◇ ZI-VPN Installer"
echo -e "${ARROW} ${GREEN}8${NC} ◇ ZI-VPN Uninstaller"
echo -e "${ARROW} ${RED}404${NC} ◇ Install Selector Tool"
echo -e "${ARROW} ${YELLOW}exit${NC} ◇ ထွက်မည်"

separator

# User Input with Myanmar prompt
while true; do
    echo -en "${HEART} ${CYAN}ရွေးချယ်မှုကို ရိုက်ထည့်ပါ (0-8/404/exit):${NC} "
    read -r user_input
    
    # Check for exit command
    if [[ "$user_input" == "exit" ]]; then
        echo -e "${CHECK} ${GREEN}ကျေးဇူးတင်ပါသည်! နောက်မှပြန်လာပါမည်။${NC}\n"
        exit 0
    fi
    
    # Input validation
    if ! [[ "$user_input" =~ ^(0|1|2|3|4|5|6|7|8|404)$ ]]; then
        echo -e "${CROSS} ${RED}မှားယွင်းနေပါသည်! 0,1,2,3,4,5,6,7,8 သို့မဟုတ် 404 ကိုသာရိုက်ပါ။${NC}\n"
        continue
    fi
    
    break
done

separator

# Execute the chosen option with loading animation
echo -e "${ARROW} ${YELLOW}လုပ်ဆောင်နေပါသည်...${NC}"
sleep 1

case $user_input in
    0)
        echo -e "${CHECK} System Update လုပ်နေပါသည်..."
        apt update && apt upgrade -y
        ;;
    1)
        echo -e "${CHECK} MHSanaei 3X-UI တပ်ဆင်နေပါသည်..."
        bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
        ;;
    2)
        echo -e "${CHECK} Alireza0 3X-UI တပ်ဆင်နေပါသည်..."
        bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
        ;;
    3)
        echo -e "${CHECK} 4-0-4 UDP Script တပ်ဆင်နေပါသည်..."
        git clone https://github.com/nyeinkokoaung404/udp-custom && cd udp-custom && chmod +x install.sh && ./install.sh
        ;;
    4)
        echo -e "${CHECK} UDP Custom Manager တပ်ဆင်နေပါသည်..."
        wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh && chmod +x install.sh && bash install.sh
        ;;
    5)
        echo -e "${CHECK} DARKSSH Manager တပ်ဆင်နေပါသည်..."
        wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark; chmod 777 Dark; ./Dark
        ;;
    6)
        echo -e "${CHECK} 404-SSH Manager တပ်ဆင်နေပါသည်..."
        wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe; chmod 777 hehe;./hehe
        ;;
    7)
        echo -e "${CHECK} ZI-VPN Installer တပ်ဆင်နေပါသည်..."
        wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh; sudo chmod +x zi.sh; sudo ./zi.sh
        ;;
    8)
        echo -e "${CHECK} ZI-VPN Uninstaller တပ်ဆင်နေပါသည်..."
        sudo wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh; sudo chmod +x ziun.sh; sudo ./ziun.sh
        ;;
    404)
        echo -e "${CHECK} Selector Tool တပ်ဆင်နေပါသည်..."
        bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
        echo -e "\n${STAR} ${GREEN}တပ်ဆင်ပြီးပါပြီ! '404' လို့ရိုက်ပြီး ပြန်ဖွင့်နိုင်ပါပြီ။${NC}"
        ;;
    *)
        echo -e "${CROSS} ${RED}မှားယွင်းနေပါသည်!${NC}"
        ;;
esac

separator
echo -e "${CHECK} ${GREEN}လုပ်ဆောင်မှု ပြီးမြောက်ပါပြီ!${NC}"
echo -e "${STAR} ${YELLOW}နောက်တစ်ခုဆက်လုပ်လိုပါက script ကို ပြန်ဖွင့်ပေးပါ။${NC}\n"
