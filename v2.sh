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
CYAN='\033[1;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Box Drawing Characters (Simplified Aesthetic from User's Example)
BOX_HORIZ="━"
BOX_VERT="┃"
BOX_CORNER_TL="┏"
BOX_CORNER_TR="┓"
BOX_CORNER_BL="┗"
BOX_CORNER_BR="┛"

# UI Settings
BOX_WIDTH=60

## ---------------------------
## Initial Checks
## ---------------------------

# Root check (Root အဖြစ်စစ်ဆေးခြင်း)
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}ဤ script ကို root အနေဖြင့်သာ run ရန် လိုအပ်ပါသည်။${NC}"
    exit 1
fi

## ---------------------------
## Helper Functions (အကူအညီပေးသော လုပ်ဆောင်ချက်များ)
## ---------------------------

# Function to get simplified uptime (uptime ကိုရယူရန်)
get_simple_uptime() {
    local uptime_seconds=$(</proc/uptime awk '{print int($1)}')
    local days=$((uptime_seconds / 60 / 60 / 24))
    local hours=$((uptime_seconds / 60 / 60 % 24))
    local minutes=$((uptime_seconds / 60 % 60))
    local output=""

    if [ "$days" -gt 0 ]; then
        output+="$days days, "
    fi
    output+="$hours hours, $minutes minutes"
    echo "$output"
}


## ---------------------------
## Display Functions (ပြသရန် လုပ်ဆောင်ချက်များ)
## ---------------------------

# Function to draw a complete box (ဘောင် အပြည့်ဆွဲရန်)
draw_box() {
    local title="$1"
    local color="$2"
    local content="$3"
    local width=$BOX_WIDTH

    # Top border
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"

    # Title line
    if [ ! -z "$title" ]; then
        local title_len=${#title}
        local padding_left=$(( (width - title_len - 2) / 2 ))
        local padding_right=$(( width - title_len - padding_left - 2 ))
        
        echo -ne "${color}${BOX_VERT}"
        printf "%${padding_left}s" ""
        echo -ne " ${WHITE}${title}${NC} "
        printf "%${padding_right}s" ""
        echo -e "${color}${BOX_VERT}${NC}"

        # Separator line
        echo -ne "${color}${BOX_VERT}"
        printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
        echo -e "${BOX_VERT}${NC}"
    fi
    
    # Content lines
    while IFS= read -r line; do
        # Clean line of color codes for length calculation
        clean_line=$(echo -e "$line" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
        local line_len=${#clean_line}
        # -3 for the two vertical borders and one space
        local content_pad=$(( width - line_len - 3 ))
        
        echo -ne "${color}${BOX_VERT}${NC} "
        echo -ne "$line"
        printf "%${content_pad}s" ""
        echo -e "${color}${BOX_VERT}${NC}"
    done <<< "$content"

    # Bottom border
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

# Display main header (ခေါင်းစဉ် ပြသရန်)
display_header() {
    clear
    local title="${WHITE}SERVER MANAGEMENT TOOLKIT v3.0${NC}"
    local dev="${WHITE}Developed by 404${NC}"
    local url="${WHITE}Contact: t.me/nkka404${NC}"

    # Title Banner (ခေါင်းစဉ် ဘောင်)
    local title_content=$(printf "%s\n%s" "$dev" "$url")
    draw_box "" $CYAN "$title_content"
    
    # Original Title Text
    termwidth=$(tput cols)
    title_text="Server Management Toolkit v3.0"
    padding=$(( (termwidth - ${#title_text}) / 2 ))
    printf "%*s${CYAN}%s${NC}\n" $padding "" "$title_text"
    echo
}

# Display system information (စနစ်အချက်အလက်များ ပြသရန်)
show_system_info() {
    local os=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || echo "Unknown OS")
    local ip_address=$(hostname -I | awk '{print $1}')
    local uptime_str=$(get_simple_uptime)

    local sysinfo=$(cat <<EOF
${CYAN}OS       ${WHITE}: ${NC}${os}
${CYAN}UPTIME   ${WHITE}: ${NC}${uptime_str}
${CYAN}IPv4     ${WHITE}: ${NC}${ip_address}
${CYAN}HOSTNAME ${WHITE}: ${NC}$(hostname)
EOF
)
    draw_box "စနစ်အချက်အလက် (System Info)" $GREEN "$sysinfo"
}

# Display the main menu (အဓိက Menu ပြသရန်)
show_menu() {
    local menu_content=$(cat <<EOF
${GREEN}[1] • စနစ် မြှင့်တင်ခြင်း (System Update)
${GREEN}[2] • Cache ရှင်းလင်းခြင်း (Clean Cache)
${GREEN}[3] • Disk နေရာ စစ်ဆေးခြင်း (Check Disk Space)
${GREEN}[4] • Server စွမ်းဆောင်ရည် စစ်ဆေးခြင်း (Benchmark)
 
${YELLOW}[5] • MHSanaei 3X-UI တပ်ဆင်ခြင်း
${YELLOW}[6] • Alireza0 3X-UI တပ်ဆင်ခြင်း
${YELLOW}[7] • ZI-VPN တပ်ဆင်ခြင်း
${YELLOW}[8] • ZI-VPN ဖယ်ရှားခြင်း
 
${CYAN}[9] • 404 UDP Boost တပ်ဆင်ခြင်း
${CYAN}[10] • UDP Custom Manager တပ်ဆင်ခြင်း
${CYAN}[11] • DARKSSH Manager တပ်ဆင်ခြင်း
${CYAN}[12] • 404-SSH Manager တပ်ဆင်ခြင်း
 
${BLUE}[13] • Selector Tool တပ်ဆင်ခြင်း
 
${RED}[00] • ထွက်ခွာရန် (EXIT)
${RED}[HELP] • အကူအညီ (Show Help)
EOF
)
    draw_box "လုပ်ဆောင်ချက်များ (Menu)" $BLUE "$menu_content"
}

# Display Footer (အောက်ခြေအချက်အလက်များ)
show_footer() {
    local footer_content=$(cat <<EOF
${WHITE}• VERSION ${CYAN}     : 3.0
${WHITE}• SCRIPT BY ${CYAN}  : 404
${WHITE}• CONTACT ${CYAN}    : t.me/nkka404
EOF
)
    draw_box "" $CYAN "$footer_content"
}


## ---------------------------
## Installation Functions (တပ်ဆင်ခြင်း လုပ်ဆောင်ချက်များ)
## ---------------------------

system_update() {
    draw_box "စနစ် မြှင့်တင်ခြင်း" $GREEN "System update လုပ်နေပါသည်..."
    apt update && apt upgrade -y
    draw_box "လုပ်ဆောင်ပြီးစီး" $GREEN "System ကို အောင်မြင်စွာ မြှင့်တင်ပြီးပါပြီ!"
}

clean_cache() {
    draw_box "Cache ရှင်းလင်းခြင်း" $GREEN "Cache ရှင်းလင်းနေပါသည်..."
    apt clean && apt autoclean
    draw_box "လုပ်ဆောင်ပြီးစီး" $GREEN "System Cache ရှင်းလင်းပြီးပါပြီ!"
}

check_disk() {
    local disk_info=$(df -h | head -n 1 && df -h | grep -E '^/dev/|Filesystem')
    draw_box "Disk နေရာ စစ်ဆေးခြင်း" $GREEN "$disk_info"
}

install_mhsanaei() {
    draw_box "MHSanaei 3X-UI တပ်ဆင်ခြင်း" $YELLOW "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
}

install_alireza() {
    draw_box "Alireza0 3X-UI တပ်ဆင်ခြင်း" $YELLOW "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    bash <(curl -Ls https://raw.githubusercontent.com/alireza0/x-ui/master/install.sh)
}

install_zivpn() {
    draw_box "ZI-VPN တပ်ဆင်ခြင်း" $YELLOW "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    wget -O zi.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/zi.sh
    chmod +x zi.sh
    ./zi.sh
}

uninstall_zivpn() {
    draw_box "ZI-VPN ဖယ်ရှားခြင်း" $YELLOW "ZI-VPN ဖယ်ရှားနေပါသည်..."
    wget -O ziun.sh https://raw.githubusercontent.com/zahidbd2/udp-zivpn/main/uninstall.sh
    chmod +x ziun.sh
    ./ziun.sh
}

install_404udp() {
    draw_box "4-0-4 UDP Script တပ်ဆင်ခြင်း" $CYAN "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    git clone https://github.com/nyeinkokoaung404/udp-custom
    cd udp-custom || exit
    chmod +x install.sh
    ./install.sh
}

install_udpmanager() {
    draw_box "UDP Custom Manager တပ်ဆင်ခြင်း" $CYAN "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    wget "https://raw.githubusercontent.com/noobconner21/UDP-Custom-Script/main/install.sh" -O install.sh
    chmod +x install.sh
    bash install.sh
}

install_darkssh() {
    draw_box "DARKSSH Manager တပ်ဆင်ခြင်း" $BLUE "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    wget https://raw.githubusercontent.com/sbatrow/DARKSSH-MANAGER/master/Dark
    chmod 777 Dark
    ./Dark
}

install_404ssh() {
    draw_box "404-SSH Manager တပ်ဆင်ခြင်း" $BLUE "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    wget https://raw.githubusercontent.com/nyeinkokoaung404/ssh-manger/main/hehe
    chmod 777 hehe
    ./hehe
}

install_selector() {
    draw_box "Selector Tool တပ်ဆင်ခြင်း" $BLUE "ခဏလေး စောင့်ဆိုင်းပေးပါ..."
    bash <(curl -fsSL https://raw.githubusercontent.com/nyeinkokoaung404/Selector/main/install.sh)
    draw_box "တပ်ဆင်ပြီးစီး" $BLUE "Tool ကို '404' command ဖြင့် run နိုင်ပါသည်။"
}

run_benchmark() {
    draw_box "Server စွမ်းဆောင်ရည် စစ်ဆေးခြင်း" $GREEN "စစ်ဆေးမှု စတင်ပါပြီ။ အချိန်အနည်းငယ် ကြာမြင့်နိုင်ပါသည်..."
    curl -sL yabs.sh | bash
}

show_help() {
    draw_box "အကူအညီ အချက်အလက်" $CYAN "
ဤ tool သည် server utilities များကို အလွယ်တကူ တပ်ဆင်နိုင်ရန် ရည်ရွယ်ပါသည်။
ရွေးချယ်မှုတိုင်းသည် software များကို အလိုအလျောက် download လုပ်ပြီး install လုပ်ပါမည်။
တပ်ဆင်မှုများ မပြုလုပ်မီ သင့်လျော်သော permission များ ရှိမရှိ သေချာပါစေ။
"
}

install_option() {
    case "$1" in
        1) system_update ;;
        2) clean_cache ;;
        3) check_disk ;;
        4) run_benchmark ;;
        5) install_mhsanaei ;;
        6) install_alireza ;;
        7) install_zivpn ;;
        8) uninstall_zivpn ;;
        9) install_404udp ;;
        10) install_udpmanager ;;
        11) install_darkssh ;;
        12) install_404ssh ;;
        13) install_selector ;;
        *) draw_box "ရွေးချယ်မှု မှားယွင်းခြင်း" $RED "ကျေးဇူးပြု၍ မှန်ကန်သော option နံပါတ်ကို ရွေးချယ်ပါ!" ;;
    esac
}

## ---------------------------
## Main Program (အဓိက အစီအစဉ်)
## ---------------------------

# Display everything initially (အစပိုင်းတွင် အားလုံးပြသရန်)
display_header
show_system_info

while true; do
    show_menu
    show_footer
    
    echo -en "${CYAN}●${NC}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ}${BOX_HORIZ} ${CYAN}ရွေးချယ်ပါ (1-13/00/help):${NC} "
    read -r user_input
    
    case "$user_input" in
        help|HELP)
            show_help
            echo -e "${YELLOW}Press any key to continue...${NC}"
            read -n 1 -s -r
            # Re-display the main UI after action
            display_header
            show_system_info
            ;;
        0|00)
            draw_box "နှုတ်ဆက်ခြင်း" $GREEN "Server Management Toolkit ကို အသုံးပြုပေးလို့ ကျေးဇူးတင်ပါတယ်!"
            echo -e "\n"
            exit 0
            ;;
        *)
            if [[ "$user_input" =~ ^[0-9]+$ ]]; then
                install_option "$user_input"
                echo -e "${YELLOW}Press any key to return to the menu...${NC}"
                read -n 1 -s -r
                # Re-display the main UI after action
                display_header
                show_system_info
            else
                draw_box "ထည့်သွင်းမှု မှားယွင်းခြင်း" $RED "ကျေးဇူးပြု၍ မှန်ကန်သော ရွေးချယ်မှု သို့မဟုတ် 'help' ကို ထည့်သွင်းပါ!"
                echo -e "${YELLOW}Press any key to continue...${NC}"
                read -n 1 -s -r
                # Re-display the main UI after action
                display_header
                show_system_info
            fi
            ;;
    esac
done
