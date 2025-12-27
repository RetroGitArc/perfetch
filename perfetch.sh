#!/bin/bash

# USER CONFIG. [Note: Input the info in "" to not let the code crash]
USER=""
TAGLINE=""
OS=""
DE=""
WM=""
WM_T=""
THEME=""
ICONS=""
GPU=""
RES=""
#REST OF CODE BELOW

IMAGE=$(jp2a ~/location_of_the_image/your-image.jpg --border --size=60x30 --color)
#IMAGE_FILE PATH ^
#Yes the Image path is made mostly dependent on jp2a but if you have any .txt file of the image you want to input, just straight away remove the entire jp2a code and replace it with "cat ~/location_of_the_file/your_file.txt)", and since its on a bash command... just use any image emulator you have loaded [except w3m, it crashed this thing x_x].

if [ -z "$IMAGE" ]; then
    IMAGE="┌──────────────┐
  NO IMAGE      
  AVAILABLE :(  
└──────────────┘"
fi
#INCASE IMAGE_FILE PATH FAILS ^

DISK_USAGE="Unknown"
if command -v df &>/dev/null; then
    DISK_USAGE=$(df -h / 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}' || echo "Unknown")
fi

MEMORY_INFO="Unknown"
if command -v free &>/dev/null; then
    MEMORY_INFO=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}' || echo "Unknown")
fi

CPU_INFO="Unknown"
if [ -f /proc/cpuinfo ]; then
    CPU_INFO=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs)
fi

PKG_COUNT="N/A"
if command -v dpkg &>/dev/null; then
    PKG_COUNT=$(dpkg --list | wc -l)
fi
#PACKAGE_COUNT, Remove if found un-necessary [Also remove the entire Line 83 if you decide to remove this PKG_COUNT]

TERMINAL=${TERM:-"Unknown"} #If $TERM is unset/null, code pastes "Unknown"

UPTIME=$(uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{print $6":"$7""}')
#$6 prints Hours, $7 prints Minutes, uptime.
#if "$(uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{print $6":"$7""}')" looks ugly/ fails to work/ just doesn't fits the vibe/ looks way too complex, this code was built on hopes and dreams, so replace that code with straight away "uptime -p" for pure simplicity.

SHELL=$(basename $SHELL 2>/dev/null || echo 'Unknown')

STRUCTURE=$(uname -m -o) 

#NOTE FOR THE COMMANDS [if you're tweaking it]:
#command -v: Portable way to check if command exists
#&>/dev/null: Suppresses all output (stdout + stderr)
#2>/dev/null: Suppresses only error messages
#awk 'NR==2': Get second line of df output [Disk output for storage]
#|| echo "Unknown": Fallback if command fails

R='\033[0;31m'         #RED
RB='\033[0;31m\033[1m' #RED+BOLD
G='\033[0;32m'         #GREEN
GB='\033[0;32m\033[1m' #GREEN+BOLD
Y='\033[0;33m'         #YELLOW
YB='\033[0;33m\033[1m' #YELLOW+BOLD
B='\033[0;34m' 	       #BLUE 
BB='\033[0;34m\033[1m' #BLUE+BOLD
CYN='\033[0;36m'       #CYAN
CYNB='\033[0;36m\033[1m' #CYAN+BOLD
P='\033[0;35m'         #PURPLE
PB='\033[0;35m\033[1m' #PURPLE+BOLD
W='\033[1;37m'         #WHITE
NC='\033[0m' #NO_COLOR(Only Applicable for the above COLORS to reset)
BLD='\033[1m' #BOLD
RST='\033[0m' #RESET(Only Applicable for BOLD)
NCR='\033[0m\033[1m' #NO_COLOR+RESET(Only Applicable for the color+bold combos)
#ANSI ESCAPE CODES [COLOURS] ^

#THE INFO BOX:
#The Colors can ofc be changed by changing the color of the command in the ${}, but only those which are mentioned the ANSI ESCAPE CODES [COLOURS], ${RST} to reset the bold as mentioned and ${NC} to reset the color to prevent overbleeding and only setting upto how much the color goes
INFO=$"${P}┌------------------------------------------------------------┐${NC}
${P}│${NC}${BLD} ${USER} │ ${TAGLINE} ${RST}
${P}├------------------------------------------------------------┤${NC}
${P}│${NC}${BLD} OS:${RST} ${OS}
${P}│${NC}${BLD} Uptime [Hrs:Mins]:${RST} ${UPTIME}
${P}│${NC}${BLD} DE:${RST} ${DE}
${P}│${NC}${BLD} WM:${RST} ${WM}
${P}│${NC}${BLD} WM Theme:${RST} ${WM_T}
${P}│${NC}${BLD} Theme:${RST} ${THEME}
${P}│${NC}${BLD} Icons:${RST} ${ICONS}
${P}│${NC}${BLD} Terminal:${RST} $TERMINAL
${P}├------------------------------------------------------------┤${NC}
${P}│${NC}${BLD} CPU:${RST} $CPU_INFO
${P}│${NC}${BLD} GPU:${RST} ${GPU}
${P}│${NC}${BLD} Memory:${RST} $MEMORY_INFO
${P}│${NC}${BLD} Packages:${RST} $PKG_COUNT
${P}├------------------------------------------------------------┤${NC}
${P}│${NC}${BLD} Shell:${RST} ${SHELL}
${P}│${NC}${BLD} Platform:${RST} $(uname -s) ${OS} $(uname -r)
${P}│${NC}${BLD} Structure:${RST} ${STRUCTURE}
${P}│${NC}${BLD} Resolution${RST}: ${RES}
${P}└------------------------------------------------------------┘${NC}"

#FINAL OUTPUT POSITIONS:
if [[ "$IMAGE" == *"NO IMAGE"* ]] || [ -z "$IMAGE" ]; then 
    echo -e "$IMAGE\n$INFO" 
    #Lets print that Image error ABOVE the INFO so ur info doesn't gets messed up :)
else
    paste <(echo -e "$IMAGE") <(echo -e "$INFO")
    #Code configured to: Image to Left, Info to Right.
fi

#NOTE FROM AUTHOR (RetroGitArc):
#This code is made for the simplicity best, as this code, even inputted in the roots, keeps no connections with the system itself, so if you're deciding to nuke this code if not satisfied, there's no issue and for the Privacy freaks, i see you, dont worry, this code only collects data to print, remove them if wanted and paste your own made up shit for shits and giggles, tweaking is HEAVILY SUPPORTED FOR THE ENTIRE CODE. [Especially for Arch / Arch based OS's users]. Anyways, Have Fun!
