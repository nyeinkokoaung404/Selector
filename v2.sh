#!/bin/bash
clear

## ---------------------------
## အခြေခံအရောင်များ
## ---------------------------
RED='\033[1;31m'      # အနီရောင်
GREEN='\033[1;32m'    # အစိမ်းရောင်
YELLOW='\033[1;33m'   # အဝါရောင်
BLUE='\033[1;34m'     # အပြာရောင်
PURPLE='\033[1;35m'   # ခရမ်းရောင်
CYAN='\033[1;36m'     # စိမ်းပြာရောင်
WHITE='\033[1;37m'    # အဖြူရောင်
NC='\033[0m'          # ရောင်ချွတ်ရန်

## ---------------------------
## အချက်အလက်များ
## ---------------------------
VERSION="2.2"
DEVELOPER="404"
CONTACT="t.me/nkka404"
UPDATE_URL="https://raw.githubusercontent.com/yourrepo/yourscript/main/script.sh"

## ---------------------------
## ဖန်ရှင်များ
## ---------------------------

# စာသားကိုအလယ်တည့်စေရန်
center_text() {
    local text="$1"
    local color="$2"
    local text_length=$(echo -n "$text" | wc -m)
    local term_width=$(tput cols)
    local padding=$(( (term_width - text_length) / 2 ))
    
    printf "%${padding}s" ""
    echo -e "${color}${text}${NC}"
}

# စနစ်အချက်အလက်များပြသရန်
show_system_info() {
    echo
    center_text "╔════════════════════════════════╗" $GREEN
    center_text "║     စနစ်အချက်အလက်များ      ║" $GREEN
    center_text "╠════════════════════════════════╣" $GREEN
    
    center_text "║ ကွန်ပျူတာအမည်: $(hostname)" $GREEN
    center_text "║ IP လိပ်စာ: $(hostname -I | awk '{print $1}')" $GREEN
    center_text "║ အလုပ်လုပ်ချိန်: $(uptime -p)" $GREEN
    center_text "║ OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)" $GREEN
    center_text "║ CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)" $GREEN
    center_text "║ မှတ်ဉာဏ်: $(free -h | awk '/Mem/{print $3"/"$2}')" $GREEN
    center_text "║ နေရာလွတ်: $(df -h / | awk 'NR==2{print $3"/"$2 " ("$5")"}')" $GREEN
    
    center_text "╚════════════════════════════════╝" $GREEN
    echo
}

# အဓိကမီနူး
show_menu() {
    clear
    center_text "╔════════════════════════════════╗" $PURPLE
    center_text "║    Server Management Toolkit   ║" $PURPLE
    center_text "║       Version $VERSION        ║" $PURPLE
    center_text "╚════════════════════════════════╝" $PURPLE
    
    show_system_info
    
    center_text "╔════════════════════════════════╗" $BLUE
    center_text "║        ရွေးချယ်ရန်          ║" $BLUE
    center_text "╠════════════════════════════════╣" $BLUE
    
    center_text "║ 0. စနစ်အသစ်များရယူရန်      ║" $CYAN
    center_text "║ 1. Cache များရှင်းရန်        ║" $CYAN
    center_text "║ 2. နေရာလွတ်စစ်ဆေးရန်        ║" $CYAN
    center_text "║ 3. Script အသစ်ရယူရန်        ║" $CYAN
    
    center_text "╠════════════════════════════════╣" $BLUE
    center_text "║ 10. MHSanaei 3X-UI တပ်ဆင်ရန် ║" $YELLOW
    center_text "║ 11. Alireza0 3X-UI တပ်ဆင်ရန် ║" $YELLOW
    center_text "║ 12. ZI-VPN တပ်ဆင်ရန်         ║" $YELLOW
    center_text "║ 13. ZI-VPN ဖျက်ရန်           ║" $YELLOW
    
    center_text "╠════════════════════════════════╣" $BLUE
    center_text "║ 20. 404 UDP Boost တပ်ဆင်ရန်  ║" $PURPLE
    center_text "║ 21. UDP Manager တပ်ဆင်ရန်    ║" $PURPLE
    center_text "║ 30. DARKSSH တပ်ဆင်ရန်        ║" $PURPLE
    center_text "║ 31. 404-SSH တပ်ဆင်ရန်        ║" $PURPLE
    
    center_text "╠════════════════════════════════╣" $BLUE
    center_text "║ 40. Selector Tool တပ်ဆင်ရန်   ║" $GREEN
    center_text "║ 41. Benchmark စစ်ဆေးရန်       ║" $GREEN
    center_text "║ 50. RDP တပ်ဆင်ရန်            ║" $GREEN
    
    center_text "╠════════════════════════════════╣" $BLUE
    center_text "║ help - အကူအညီကြည့်ရန်        ║" $RED
    center_text "║ exit - ထွက်ရန်                ║" $RED
    center_text "╚════════════════════════════════╝" $BLUE
    echo
}

## ---------------------------
## အခြေခံစစ်ဆေးမှုများ
## ---------------------------

# Root ဟုတ်မဟုတ်စစ်ဆေးခြင်း
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}ဤ Script ကို root အဖြစ်သာအသုံးပြုနိုင်ပါသည်!${NC}"
    exit 1
fi

# လိုအပ်သော package များစစ်ဆေးခြင်း
check_dependencies() {
    if ! command -v figlet &> /dev/null; then
        echo -e "${YELLOW}figlet တပ်ဆင်နေသည်...${NC}"
        apt-get update && apt-get install -y figlet
    fi
    
    if ! command -v screen &> /dev/null; then
        echo -e "${YELLOW}screen တပ်ဆင်နေသည်...${NC}"
        apt-get install -y screen
    fi
}
check_dependencies

## ---------------------------
## အဓိကလုပ်ဆောင်ချက်များ
## ---------------------------

system_update() {
    echo -e "${YELLOW}စနစ်အသစ်များရယူနေသည်...${NC}"
    apt update && apt upgrade -y
    echo -e "${GREEN}အသစ်များရယူပြီးပါပြီ!${NC}"
}

clean_cache() {
    echo -e "${YELLOW}Cache များရှင်းနေသည်...${NC}"
    apt clean && apt autoclean
    echo -e "${GREEN}Cache ရှင်းပြီးပါပြီ!${NC}"
}

update_script() {
    echo -e "${YELLOW}Script အသစ်ရှာနေသည်...${NC}"
    if wget -q --spider $UPDATE_URL; then
        wget -O $0 $UPDATE_URL
        echo -e "${GREEN}Script အသစ်ရပြီး ပြန်လည်စတင်နေပါပြီ...${NC}"
        exec $0
    else
        echo -e "${RED}Update လုပ်ရန် မအောင်မြင်ပါ!${NC}"
    fi
}

# အခြား function များကို သင့်လိုအပ်ချက်နှင့်အညီ ထည့်သွင်းနိုင်ပါသည်...

## ---------------------------
## အဓိက Program
## ---------------------------

while true; do
    show_menu
    
    echo -en "${CYAN}ရွေးချယ်မှုကိုရိုက်ထည့်ပါ: ${NC}"
    read -r choice
    
    case $choice in
        0) system_update ;;
        1) clean_cache ;;
        2) check_disk ;;
        3) update_script ;;
        help)
            clear
            center_text "╔════════════════════════════════╗" $GREEN
            center_text "║          အကူအညီ          ║" $GREEN
            center_text "╠════════════════════════════════╣" $GREEN
            center_text "║ နံပါတ်ရိုက်ပြီးရွေးချယ်ပါ ║" $GREEN
            center_text "║ help - အကူအညီကြည့်ရန်    ║" $GREEN
            center_text "║ exit - ထွက်ရန်          ║" $GREEN
            center_text "╚════════════════════════════════╝" $GREEN
            ;;
        exit)
            echo -e "${GREEN}ကျေးဇူးတင်ပါသည်!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}မှားယွင်းသောရွေးချယ်မှု!${NC}"
            ;;
    esac
    
    echo -e "${YELLOW}ဆက်လုပ်ရန် မည်သည့်ခလုတ်ကိုမဆိုနှိပ်ပါ...${NC}"
    read -n 1 -s -r
done
