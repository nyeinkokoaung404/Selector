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

# Box Drawing Characters
BOX_HORIZ="═"
BOX_VERT="║"
BOX_CORNER_TL="╔"
BOX_CORNER_TR="╗"
BOX_CORNER_BL="╚"
BOX_CORNER_BR="╝"

## ---------------------------
## Centering Functions
## ---------------------------

calculate_padding() {
    local text="$1"
    # Remove color codes for accurate length calculation
    local clean_text=$(echo -e "$text" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
    local text_length=${#clean_text}
    local term_width=$(tput cols)
    echo $(( (term_width - text_length) / 2 ))
}

print_centered() {
    local text="$1"
    local color="$2"
    local padding=$(calculate_padding "$text")
    
    printf "%${padding}s" ""
    echo -e "${color}${text}${NC}"
}

draw_box_top() {
    local color="$1"
    local width="$2"
    echo -ne "${color}${BOX_CORNER_TL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_TR}${NC}"
}

draw_box_bottom() {
    local color="$1"
    local width="$2"
    echo -ne "${color}${BOX_CORNER_BL}"
    printf "%0.s${BOX_HORIZ}" $(seq 1 $((width-2)))
    echo -e "${BOX_CORNER_BR}${NC}"
}

draw_box_line() {
    local text="$1"
    local box_color="$2"
    local text_color="$3"
    local width="$4"
    
    # Calculate padding
    local clean_text=$(echo -e "$text" | sed -r "s/\x1B\[([0-9]{1,3}(;[0-9]{1,2})?)?[mGK]//g")
    local text_length=${#clean_text}
    local total_padding=$((width - text_length - 2)) # -2 for borders
    local padding_left=$((total_padding / 2))
    local padding_right=$((total_padding - padding_left))
    
    echo -ne "${box_color}${BOX_VERT}${NC}"
    printf "%${padding_left}s" ""
    echo -ne "${text_color}${text}${NC}"
    printf "%${padding_right}s" ""
    echo -e "${box_color}${BOX_VERT}${NC}"
}

## ---------------------------
## Menu Display
## ---------------------------

show_menu() {
    local menu_width=50
    
    # Header
    draw_box_top $PURPLE $menu_width
    draw_box_line "   SERVER MANAGEMENT TOOLKIT   " $PURPLE $WHITE $menu_width
    draw_box_line "          Version 2.2         " $PURPLE $CYAN $menu_width
    draw_box_bottom $PURPLE $menu_width
    
    # System Info
    draw_box_top $GREEN $menu_width
    draw_box_line "       SYSTEM INFORMATION     " $GREEN $WHITE $menu_width
    draw_box_line " Hostname: $(hostname)" $GREEN $NC $menu_width
    draw_box_line " IP: $(hostname -I | awk '{print $1}')" $GREEN $NC $menu_width
    draw_box_line " Uptime: $(uptime -p)" $GREEN $NC $menu_width
    draw_box_bottom $GREEN $menu_width
    
    # Main Menu
    draw_box_top $BLUE $menu_width
    draw_box_line "          MAIN MENU           " $BLUE $WHITE $menu_width
    draw_box_line " 1. System Update             " $BLUE $CYAN $menu_width
    draw_box_line " 2. System Cleanup            " $BLUE $CYAN $menu_width
    draw_box_line " 3. Check Resources           " $BLUE $CYAN $menu_width
    draw_box_line " 4. Install VPN Panel         " $BLUE $YELLOW $menu_width
    draw_box_line " 5. Install Speed Tools       " $BLUE $YELLOW $menu_width
    draw_box_line " 6. Install Management Tools  " $BLUE $PURPLE $menu_width
    draw_box_line " 7. Help & Information        " $BLUE $RED $menu_width
    draw_box_line " 8. Exit                      " $BLUE $RED $menu_width
    draw_box_bottom $BLUE $menu_width
}

## ---------------------------
## Main Execution
## ---------------------------

while true; do
    show_menu
    
    echo -ne "${CYAN}Enter your choice (1-8): ${NC}"
    read -r choice
    
    case $choice in
        [1-8]) 
            echo -e "${GREEN}You selected option $choice${NC}"
            ;;
        *)
            echo -e "${RED}Invalid selection! Please choose 1-8.${NC}"
            ;;
    esac
    
    read -n 1 -s -r -p "Press any key to continue..."
    clear
done
