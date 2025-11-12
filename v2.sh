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

# Box Drawing Characters (Simplified)
BOX_HORIZ="─"
BOX_VERT="│"
BOX_CORNER_TL="╭"
BOX_CORNER_TR="╮"
BOX_CORNER_BL="╰"
BOX_CORNER_BR="╯"

# UI Elements
CHECK="${GREEN}✔${NC}"
CROSS="${RED}✖${NC}"
ARROW="${CYAN}»${NC}"
STAR="${YELLOW}★${NC}"
HEART="${RED}♥${NC}"
DIAMOND="${BLUE}◆${NC}"

## ---------------------------
## Initial Checks
## ---------------------------

# Root check (Allowing this line to remain in English for standard technical output)
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}This script must be run as root!${NC}"
    exit 1
fi

## ---------------------------
## Display Functions (Simplified and improved)
## ---------------------------

# Function to display a simple, clear box for messages and data
draw_box() {
    local title="$1"
    local color="$2"
    local content="$3"
    local box_width=60
    local title_len=${#title}
    
    # Top border with title centered
    local top_left=$(( (box_width - title_len - 4) / 2 ))
    local top_right=$(( box_width - title_len - top_left - 4 ))
    
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $top_left)
    echo -ne "[ ${WHITE}${title}${color} ]"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $top_right)
    echo -e "${BOX_CORNER_TR}${NC}"
    
    # Content lines
    while IFS= read -r line; do
        # Remove color codes for length calculation
        clean_line=$(echo -e "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        local line_len=${#clean_line}
        local content_pad=$(( box_width - line_len - 3 ))
        
        echo -ne "${color}${BOX_VERT}${NC} "
        echo -ne "$line"
        printf "%${content_pad}s" ""
        echo -e "${color}${BOX_VERT}${NC}"
    done <<< "$content"
    
    # Bottom border
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((box_width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

# System information display (Updated with Burmese title)
show_system_info() {
    local sysinfo=$(cat <<EOF
${STAR} ${GREEN}Hostname:${NC} $(hostname)
${STAR} ${GREEN}IP Address:${NC} $(hostname -I | awk '{print $1}')
${STAR} ${GREEN}Uptime:${NC} $(uptime -p | sed 's/up //')
${STAR} ${GREEN}OS:${NC} $(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Unknown Linux")
${STAR} ${GREEN}CPU:${NC} $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs | head -n 1)
${STAR} ${GREEN}Memory:${NC} $(free -h | awk '/Mem/{print $3"/"$2}' | tr -d ' ')
${STAR} ${GREEN}Disk Usage:${NC} $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')
EOF
)
    draw_box "စနစ်ဆိုင်ရာ အချက်အလက်များ" $GREEN 60 "$sysinfo"
}

# Beautiful header (Simplified)
display_header() {
    clear
    local termwidth=$(tput cols)
    local title="ဆာဗာ စီမံခန့်ခွဲရေး ကိရိယာအစုံ v2.0"
    local dev="ဆက်သွယ်ရန်: t.me/nkka404"
    
    echo -e "${PURPLE}======================================================${NC}"
    printf "${PURPLE}%*s%s%*s${NC}\n" $(((termwidth - ${#title}) / 2)) "" "$title" $(((termwidth - ${#title}) / 2)) ""
    printf "${GREEN}%*s%s%*s${NC}\n" $(((termwidth - ${#dev}) / 2)) "" "$dev" $(((termwidth - ${#dev}) / 2)) ""
    echo -e "${PURPLE}======================================================${NC}"
    echo
}

## ---------------------------
## Menu Layout (Simplified and Modular)
## ---------------------------

# Function to display a menu section
display_section() {
    local title="$1"
    local color="$2"
    local content="$3"
    
    echo -e "${color}${ARROW} ${WHITE}${title}${NC}"
    echo -e "${content}"
    echo -e "${color}--------------------------------------${NC}"
}

show_menu() {
    echo -e "\n${CYAN}╭───────────────────────────────────────────────────╮${NC}"
    echo -e "${CYAN}│ ${WHITE} ပင်မ ရွေးချယ်စရာများ စာရင်း ${CYAN} │${NC}"
    echo -e "${CYAN}├───────────────────────────────────────────────────┤${NC}"
    
    # 1. System Management
    local sys_mgmt=$(cat <<EOF
${ARROW} ${GREEN}[0] ${WHITE}စနစ် မွမ်းမံခြင်း (System Update)
${ARROW} ${GREEN}[1] ${WHITE}စနစ် ကက်ရှ် သန့်ရှင်းရေး (Clean System Cache)
${ARROW} ${GREEN}[2] ${WHITE}ဒစ်ခ် နေရာ စစ်ဆေးခြင်း (Check Disk Space)
EOF
)
    display_section "စနစ် စီမံခန့်ခွဲမှု" $GREEN "$sys_mgmt"
    
    # 2. VPN Panels
    local vpn_panels=$(cat <<EOF
${ARROW} ${YELLOW}[10] ${WHITE}MHSanaei 3X-UI ထည့်သွင်းရန်
${ARROW} ${YELLOW}[11] ${WHITE}Alireza0 3X-UI ထည့်သွင်းရန်
${ARROW} ${YELLOW}[12] ${WHITE}ZI-VPN ထည့်သွင်းရန် (Install)
${ARROW} ${YELLOW}[13] ${WHITE}ZI-VPN ဖယ်ရှားရန် (Uninstall)
EOF
)
    display_section "VPN ထိန်းချုပ်ခုံများ" $YELLOW "$vpn_panels"
    
    # 3. Speed Optimization
    local speed_opt=$(cat <<EOF
${ARROW} ${CYAN}[20] ${WHITE}404 UDP Boost ထည့်သွင်းရန်
${ARROW} ${CYAN}[21] ${WHITE}UDP Custom Manager ထည့်သွင်းရန်
EOF
)
    display_section "အမြန်နှုန်း မြှင့်တင်ခြင်း" $CYAN "$speed_opt"
    
    # 4. SSH Managers
    local ssh_mgmt=$(cat <<EOF
${ARROW} ${BLUE}[30] ${WHITE}DARKSSH Manager ထည့်သွင်းရန်
${ARROW} ${BLUE}[31] ${WHITE}404-SSH Manager ထည့်သွင်းရန်
EOF
)
    display_section "SSH မန်နေဂျာများ" $BLUE "$ssh_mgmt"
    
    # 5. Tools & Others
    local tools_others=$(cat <<EOF
${ARROW} ${PURPLE}[40] ${WHITE}Selector Tool ထည့်သွင်းရန်
${ARROW} ${PURPLE}[41] ${WHITE}ဆာဗာ စွမ်းဆောင်ရည် စစ်ဆေးရန် (Benchmark)
${ARROW} ${RED}help ${WHITE}အကူအညီ ပြသရန်
${ARROW} ${RED}exit ${WHITE}ပရိုဂရမ်မှ ထွက်ရန်
EOF
)
    display_section "ကိရိယာများ & အခြား ရွေးချယ်စရာများ" $PURPLE "$tools_others"
    
    echo -e "${CYAN}╰───────────────────────────────────────────────────╯${NC}"
}

## ---------------------------
## Installation Functions (kept in English for technical logic)
## ---------------------------

system_update() {
    draw_box "စနစ် မွမ်းမံခြင်း" $GREEN "မွမ်းမံမှုများ လုပ်ဆောင်နေပါသည်..."
    apt update && apt upgrade -y
    draw_box "မွမ်းမံမှု ပြီးဆုံးခြင်း" $GREEN "စနစ်ကို အောင်မြင်စွာ မွမ်းမံပြီးပါပြီ!"
}

clean_cache() {
    draw_box "ကက်ရှ် သန့်ရှင်းရေး" $GREEN "စနစ် ကက်ရှ်ကို ရှင်းလင်းနေပါသည်..."
    apt clean && apt autoclean
    draw_box "ကက်ရှ် ရှင်းလင်းပြီး" $GREEN "စနစ် ကက်ရှ်ကို ရှင်းလင်းပြီးပါပြီ!"
}

check_disk() {
    local disk_info=$(df -h)
    draw_box "ဒစ်ခ် နေရာ စစ်ဆေးခြင်း" $GREEN "$disk_info"
}

install_mhsanaei() {
    draw_box "MHSanaei 3X-UI ထည့်သွင်းခြင်း" $YELLOW "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
    echo -e "\n${CHECK} MHSanaei 3X-UI ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

install_alireza() {
    draw_box "Alireza0 3X-UI ထည့်သွင်းခြင်း" $YELLOW "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
    echo -e "\n${CHECK} Alireza0 3X-UI ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

install_zivpn() {
    draw_box "ZI-VPN ထည့်သွင်းခြင်း" $YELLOW "စတင် ထည့်သွင်းပါသည်..."
    wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
    chmod +x zi.sh
    ./zi.sh
    echo -e "\n${CHECK} ZI-VPN ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

uninstall_zivpn() {
    draw_box "ZI-VPN ဖယ်ရှားခြင်း" $YELLOW "ZI-VPN ကို ဖယ်ရှားနေပါသည်..."
    wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
    chmod +x ziun.sh
    ./ziun.sh
    echo -e "\n${CHECK} ZI-VPN ဖယ်ရှားမှု ပြီးဆုံးပါပြီ။"
}

install_404udp() {
    draw_box "4-0-4 UDP Script ထည့်သွင်းခြင်း" $CYAN "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    git clone https://github.com/nyeinkokoaung404/udp-custom || { echo -e "${CROSS} Git Clone မအောင်မြင်ပါ"; return 1; }
    cd udp-custom || { echo -e "${CROSS} Directory သို့ မဝင်နိုင်ပါ"; return 1; }
    chmod +x install.sh
    ./install.sh
    cd .. # Go back to original directory
    echo -e "\n${CHECK} 4-0-4 UDP Script ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

install_udpmanager() {
    draw_box "UDP Custom Manager ထည့်သွင်းခြင်း" $CYAN "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
    chmod +x install.sh
    bash install.sh
    echo -e "\n${CHECK} UDP Custom Manager ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

install_darkssh() {
    draw_box "DARKSSH Manager ထည့်သွင်းခြင်း" $BLUE "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark -O Dark
    chmod 777 Dark
    ./Dark
    echo -e "\n${CHECK} DARKSSH Manager ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

install_404ssh() {
    draw_box "404-SSH Manager ထည့်သွင်းခြင်း" $BLUE "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe -O hehe
    chmod 777 hehe
    ./hehe
    echo -e "\n${CHECK} 404-SSH Manager ထည့်သွင်းမှု ပြီးဆုံးပါပြီ။"
}

install_selector() {
    draw_box "Selector Tool ထည့်သွင်းခြင်း" $PURPLE "မိနစ်အနည်းငယ် ကြာနိုင်ပါသည်..."
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    draw_box "ထည့်သွင်းမှု ပြီးဆုံး" $PURPLE "ယခုအခါ '404' command ဖြင့် tool ကို run နိုင်ပါပြီ။"
}

run_benchmark() {
    draw_box "ဆာဗာ စွမ်းဆောင်ရည် စစ်ဆေးခြင်း" $PURPLE "စစ်ဆေးမှု စတင်ပါပြီ။ အချိန်အနည်းငယ် ကြာမြင့်နိုင်ပါသည်..."
    curl -sL yabs.sh | bash
    echo -e "\n${CHECK} စွမ်းဆောင်ရည် စစ်ဆေးမှု ပြီးဆုံးပါပြီ။"
}

show_help() {
    draw_box "အကူအညီဆိုင်ရာ အချက်အလက်များ" $CYAN "\
${ARROW} ${GREEN}ဤ tool သည် ဆာဗာ utility များကို လျင်မြန်စွာ ထည့်သွင်းရန် ကူညီပေးပါသည်။${NC}\n\
${ARROW} ${YELLOW}ရွေးချယ်စရာတိုင်းသည် software ကို အလိုအလျောက် download လုပ်ပြီး install လုပ်ပါမည်။${NC}\n\
${ARROW} ${RED}ထည့်သွင်းခြင်းမပြုမီ သင့်လျော်သော root ခွင့်ပြုချက်များ ရှိရန် သေချာပါစေ။${NC}"
}

install_option() {
    case $1 in
        0) system_update ;;
        1) clean_cache ;;
        2) check_disk ;;
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
        *) draw_box "မှားယွင်းသော ရွေးချယ်မှု" $RED "ကျေးဇူးပြု၍ မှန်ကန်သော နံပါတ်ကို ရွေးချယ်ပါ!" ;;
    esac
}

## ---------------------------
## Main Program
## ---------------------------
display_header
show_system_info

while true; do
    show_menu
    
    echo -en "${HEART} ${CYAN}သင်၏ ရွေးချယ်မှုကို ထည့်ပါ (0-41/help/exit):${NC} "
    read -r user_input
    
    case $user_input in
        help)
            show_help
            echo -e "${STAR} ${YELLOW}ဆက်လက်လုပ်ဆောင်ရန် မည်သည့် ခလုတ်ကိုမဆို နှိပ်ပါ...${NC}"
            read -n 1 -s -r
            ;;
        exit)
            draw_box "နှုတ်ဆက်ခြင်း" $GREEN "Server Management Toolkit ကို အသုံးပြုသည့်အတွက် ကျေးဇူးတင်ပါသည်!"
            echo -e "\n"
            exit 0
            ;;
        *)
            if [[ "$user_input" =~ ^[0-9]+$ ]]; then
                install_option "$user_input"
                echo -e "${STAR} ${YELLOW}Menu သို့ ပြန်သွားရန် မည်သည့် ခလုတ်ကိုမဆို နှိပ်ပါ...${NC}"
                read -n 1 -s -r
            else
                draw_box "မှားယွင်းသော ထည့်သွင်းမှု" $RED "မှန်ကန်သော ရွေးချယ်မှု (နံပါတ်/help/exit) ကို ထည့်ပါ!"
                echo -e "${STAR} ${YELLOW}ဆက်လက်လုပ်ဆောင်ရန် မည်သည့် ခလုတ်ကိုမဆို နှိပ်ပါ...${NC}"
                read -n 1 -s -r
            fi
            ;;
    esac
done
