#!/bin/bash

# --- INDEX ---
#1. USER INPUT AREA / CONFIGURATION - Line: 24
#2. IMAGE FILE PATH - Line: 32
#3. OS DETECTION - Line: 36
#4. Function to display ASCII of the related OS (from OS_T [OS_Theme]) - Line: 42
#5. ANSI ESCAPE CODES & COLORS - Line: 117
#6. MEMORY INFO DETECTION - Line: 138
#7. CPU INFO DETECTION - Line: 147
#8. PACKAGE COUNT / INFO DETECTION - Line: 154
#9. DE [Desktop Environment] & WM [Window Manager] DETECTION - Line: 174
#10. GPU INFO DETECTION - Line: 207
#11. TERMINAL INFO DETECTION - Line: 213
#12. UPTIME DETECTION - Line: 222
#13. SHELL INFO AND VERSION DETECTION - Line: 227
#14. OS STRUCTURE DETECTION - Line: 247
#15. Function to display proper box color respective to the OS_T [OS_Theme] - Line: 250
#16. OS_COL [OS_Color] function to personalization - Line: 308
#17. BOX BORDER FUNCTION - Line: 324
#18. THE INFO BOX - Line: 333
#19. FINAL OUTPUT POSITIONS - Line: 358

#1. USER INPUT AREA / CONFIGURATION ----->
USER=$(whoami)
TAGLINE=$(pwd)
WM_T="[User-Input / Removable]" #(remove line 342 additionally too if you decide to remove WM_T [Window Manager_Theme])
THEME="[User-Input / Removable]" #(remove line 343 additionally too if you decide to remove THEME)
ICONS="[User-Input / Removable]" #(remove line 344 additionally too if you decide to remove ICONS)
RES="[User-Input / Removable]" #(remove line 354 additionally too if you decide to remove RES [Resolution])

#2. IMAGE FILE PATH ----->
IMAGE=$()
#The Image path is made dependent on jp2a but if you have any .txt file of the image you want to input, just straight away remove the entire jp2a code and replace it with "cat ~/location_of_the_file/your_file.txt)", and since its on a bash command... just use any image emulator you have loaded.

#3. OS DETECTION ----->
OS_T="Unknown OS" 
if [ -f /etc/os-release ]; then
   OS_T=$(cat /etc/os-release | grep PRETTY_NAME /etc/os-release | cut -d\" -f2)
fi

#4. Function to display ASCII of the related OS (from OS_T [OS_Theme]) ----->
declare -A LOGO_MAP=(
    ["Unknown"]="unknown.txt"
    ["Kubuntu"]="kubuntu.txt"
    ["Xubuntu"]="xubuntu.txt"
    ["Lubuntu"]="lubuntu.txt"
    ["Ubuntu MATE"]="ubuntu_mate.txt"
    ["Ubuntu GNOME"]="ubuntu_gnome.txt"
    ["Ubuntu Studio"]="ubuntu_studio.txt"
    ["Ubuntu Budgie"]="ubuntu_budgie.txt"
    ["Ubuntu"]="ubuntu.txt"
    ["Redhat"]="redhat.txt"
    ["Dragonfly"]="dragonfly.txt"
    ["Alpine"]="alpine.txt"
    ["Fedora"]="fedora.txt"
    ["Kali"]="kali.txt"
    ["Debian"]="debian.txt"
    ["Linux Mint"]="mint.txt"
    ["Arch"]="arch.txt"
    ["Arco"]="arco.txt"
    ["openSUSE Tumbleweed"]="SUSE tumbleweed.txt"
    ["openSUSE Leap"]="SUSE leap.txt"
    ["Manjaro"]="manjaro.txt"
    ["Zorin"]="zorin.txt"
    ["Steam"]="steam.txt"
    ["Void"]="void.txt"
    ["Pop"]="pop.txt"
    ["Elementary"]="elementary.txt"
    ["Slackware"]="slackware.txt"
    ["Endeavour"]="endeavour.txt"
    ["FreeBSD"]="freebsd.txt"
    ["macOS"]="mac.txt"
    ["NixOS"]="nix.txt"
    ["OpenBSD"]="openbsd.txt"
    ["Garuda"]="garuda.txt"
)

LOGO_FILE=""
for key in "${!LOGO_MAP[@]}"; do
    if [[ "$OS_T" == *"Ubuntu Studio"* ]]; then
    	LOGO_FILE="${LOGO_MAP[Ubuntu Studio]}"
    	break
    fi
    if [[ "$OS_T" == *"Ubuntu Budgie"* ]]; then
    	LOGO_FILE="${LOGO_MAP[Ubuntu Budgie]}"
    	break
    fi
    if [[ "$OS_T" == *"$key"* ]]; then
        LOGO_FILE="${LOGO_MAP[$key]}"
        break
    fi
done

if [ -z "$IMAGE" ] && [ -n "$LOGO_FILE" ]; then

LOGO_DIR=""
    for dir in \
    	$(find $HOME -type d -name "perfetch-logos") \
        "/usr/local/bin/perfetch-logos" ; do 
        
        if [ -d "$dir" ] && [ -f "$dir/$LOGO_FILE" ]; then
            LOGO_DIR="$dir"
            break
        fi
    done
    
#{$(find $HOME -type d -name "perfetch-logos") \} Search in home.
#{"/usr/local/bin/perfetch-logos" ; do} Search in root - specifically pointed to usr/local/bin.

    # Once found, logo loader.
    if [ -n "$LOGO_DIR" ]; then
        IMAGE=$(cat "$LOGO_DIR/$LOGO_FILE")
    fi
fi

#5. ANSI ESCAPE CODES & COLORS ----->
OR='\033[38;5;208m'		#ORANGE
ORB='\033[38;5;208m\033[1m' 	#ORANGE+BOLD
R='\033[0;31m'         		#RED
RB='\033[0;31m\033[1m' 		#RED+BOLD
G='\033[0;32m'        		#GREEN
GB='\033[0;32m\033[1m' 		#GREEN+BOLD
Y='\033[0;33m'         		#YELLOW
YB='\033[0;33m\033[1m' 		#YELLOW+BOLD
B='\033[0;34m' 	       		#BLUE 
BB='\033[0;34m\033[1m' 		#BLUE+BOLD
CYN='\033[0;36m'       		#CYAN
CYNB='\033[0;36m\033[1m' 	#CYAN+BOLD
P='\033[0;35m'         		#PURPLE
PB='\033[0;35m\033[1m' 		#PURPLE+BOLD
W='\033[1;37m'         		#WHITE
NC='\033[0m' 			#NO_COLOR(Only Applicable for the above COLORS to reset)
BLD='\033[1m' 			#BOLD
RST='\033[0m' 			#RESET(Only Applicable for BOLD)
NCR='\033[0m\033[1m' 		#NO_COLOR+RESET(Only Applicable for the color+bold combos)

#6. MEMORY INFO DETECTION ----->
MEMORY_INFO="Unknown"
if command -v free >/dev/null; then
    MEM_TOTAL=$(free -h | grep Mem: | awk '{print $2}')
    MEM_USED=$(free -h | grep Mem: | awk '{print $3}')
    MEM_PERCENT=$(free | grep Mem: | awk '{printf "%.0f", $3/$2 * 100}')
    MEMORY_INFO="$MEM_USED / $MEM_TOTAL ($MEM_PERCENT%)"
fi

#7. CPU INFO DETECTION ----->
CPU_INFO="Unknown"
if [ -f /proc/cpuinfo ]; then
token=($(grep --max-count=1 "model name" /proc/cpuinfo))
CPU_INFO=$(echo "${token[@]:3}")
fi

#8. PACKAGE COUNT / INFO DETECTION ----->
PKG_INFO="No Info"
#Debian/Ubuntu based packages (deb)
if command -v dpkg &>/dev/null; then
    DEB_PKG=$(dpkg --list | grep '^ii' | wc -l)
fi
#Fedora/RHEL based packages (rpm)
if command -v rpm &>/dev/null; then
    RPM_PKG=$(rpm -qa | wc -l)
fi
#Python pip based packages (pip)
if command -v pip &>/dev/null; then
    PIP_PKG=$(pip list 2>/dev/null | tail -n +3 | wc -l)
fi
#Flatpak-system based packages (flatpak-system)
if command -v flatpak &>/dev/null; then
    FLATPAK=$(flatpak list 2>/dev/null | tail -n +2 | wc -l)
fi
PKG_COUNT="$DEB_PKG (deb), $RPM_PKG (rpm), $PIP_PKG (pip), $FLATPAK (flatpak-system)"

#9. DE [Desktop Environment] & WM [Window Manager] DETECTION ----->
DE="Unknown"
WM="Unknown"
if [ "$XDG_CURRENT_DESKTOP" ]; then
    DE="$XDG_CURRENT_DESKTOP"
elif [ "$DESKTOP_SESSION" ]; then
    DE="$DESKTOP_SESSION"
fi

if pidof gnome-shell >/dev/null; then
    DE="GNOME"
    WM="Mutter"
elif pidof plasmashell >/dev/null; then
    DE="KDE Plasma"
    WM="KWin"
elif pidof xfce4-session >/dev/null; then
    DE="XFCE"
    WM="Xfwm"
fi
#GNOME version search if GNOME
if [ "$DE" = "GNOME" ] || [ "$DE" = "gnome" ]; then
    GNOME_VER=$(gnome-shell --version 2>/dev/null | cut -d' ' -f3)
    if [ "$GNOME_VER" ]; then
        DE="GNOME $GNOME_VER"
    fi
fi
#display server search if Wayland/X11
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    DE="$DE (Wayland)"
elif [ "$XDG_SESSION_TYPE" = "x11" ]; then
    DE="$DE (X11)"
fi

#10. GPU INFO DETECTION ----->
GPU="Unknown"
if command -v lspci >/dev/null; then
    GPU=$(lspci | grep -i "vga\|3d\|display" | head -n1 | cut -d: -f3 | xargs)
fi

#11. TERMINAL INFO DETECTION ----->
TERMINAL="Unknown"
if [ "$TERM" ]; then
    TERMINAL="$TERM"
fi
if [ "$TERM_PROGRAM" ]; then
    TERMINAL="$TERM_PROGRAM"
fi

#12. UPTIME DETECTION ----->
UPTIME=$(uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{print $6" Hrs "$7" Mins"}')
#$6 prints Hours, $7 prints Minutes, uptime.
#if "$(uptime -p 2>/dev/null || uptime | awk -F'( |,|:)+' '{print $6":"$7""}')" looks ugly/fails to work/looks way too complex, replace the code with straight away "uptime -p" for simplicity.

#13. SHELL INFO AND VERSION DETECTION ----->
SHELL_INFO="Unknown"
if [ -n "$SHELL" ]; then
    SHELL_NAME=$(basename "$SHELL")
    case $SHELL_NAME in
        bash)
            SHELL_INFO="bash $BASH_VERSION"
            ;;
        zsh)
            SHELL_INFO="zsh $ZSH_VERSION"
            ;;
        fish)
            SHELL_INFO="fish $(fish --version 2>/dev/null | cut -d' ' -f3)"
            ;;
        *)
            SHELL_INFO="$SHELL_NAME"
            ;;
    esac
fi

#14. OS STRUCTURE DETECTION ----->
STRUCTURE=$(uname -m -o) 

#15. Function to display proper box color respective to the OS_T [OS_Theme] ----->
declare -A COL_STRUT=(
    ["Unknown"]="${BLD}"
    ["Kubuntu"]="${BB}"
    ["Xubuntu"]="${BB}"
    ["Lubuntu"]="${CYNB}"
    ["Ubuntu MATE"]="${G}"
    ["Ubuntu GNOME"]="${CYNB}"
    ["Ubuntu Studio"]="${BB}"
    ["Ubuntu Budgie"]="${BLD}"
    ["Ubuntu"]="${ORB}"
    ["Redhat"]="${RB}"
    ["Dragonfly"]="${PB}"
    ["Alpine"]="${CYN}"
    ["Fedora"]="${CYNB}"
    ["Kali"]="${BB}"
    ["Debian"]="${RB}"
    ["Linux Mint"]="${G}"
    ["Arch"]="${CYNB}"
    ["Arco"]="${BB}"
    ["openSUSE Tumbleweed"]="${G}"
    ["openSUSE Leap"]="${GB}"
    ["Manjaro"]="${GB}"
    ["Zorin"]="${CYNB}"
    ["Steam"]="${BB}"
    ["Void"]="${G}"
    ["Pop"]="${CYNB}"
    ["Elementary"]="${CYNB}"
    ["Slackware"]="${BB}"
    ["Endeavour"]="${BB}"
    ["FreeBSD"]="${RB}"
    ["macOS"]="${CYNB}"
    ["NixOS"]="${CYNB}"
    ["OpenBSD"]="${YB}"
    ["Garuda"]="${RB}"
)

COL_CHOI=""
for key in "${!COL_STRUT[@]}"; do
    if [[ "$OS_T" == *"Ubuntu Studio"* ]]; then
    	COL_CHOI="${COL_STRUT[Ubuntu Studio]}"
    	break
    fi
    if [[ "$OS_T" == *"Ubuntu Budgie"* ]]; then
    	COL_CHOI="${COL_STRUT[Ubuntu Budgie]}"
    	break
    fi
    if [[ "$OS_T" == *"$key"* ]]; then
        COL_CHOI="${COL_STRUT[$key]}"
        break
    fi
done

if [ -n "$COL_CHOI" ]; then
#Function to change box color, change {COL_CHOI} [Color_Choice] to any color of your choice from [5. ANSI ESCAPE CODES & COLORS] on Line: 117 to change the entire box color.
BOX_COL=${COL_CHOI} 
fi

#16. OS_COL [OS_Color] function to personalization ----->
if [[ "$OS_T" == *"Garuda"* ]]; then
OS_COL=${PB}
elif [[ "$COL_CHOI" = "${BB}" ]]; then
OS_COL=${CYNB}
elif [[ "$COL_CHOI" = "${G}" ]]; then
OS_COL=${GB}
elif [[ "$COL_CHOI" = "${BLD}" ]]; then
OS_COL=${CYNB}
elif [[ "$COL_CHOI" = "${CYN}" ]]; then
OS_COL=${CYNB}
else
OS_COL=${COL_CHOI} 
fi
#Function to select colour of OS to display as OS_T guesses the OS.

#17. BOX BORDER FUNCTION ----->
box.size(){
box_s=65
for((i=0;i<=$box_s;i++))
do
	echo -n "-"
done
}

#18. THE INFO BOX ----->
INFO=$"${BOX_COL}+$(box.size)+${NCR}
${BOX_COL}|${NCR}${BLD} ${CYNB}${USER}${NCR} | ${PB}${TAGLINE}${NCR} ${RST}
${BOX_COL}|$(box.size)+${NCR}
${BOX_COL}|${NCR}${BLD} > OS:${RST} ${OS_COL}${OS_T}${NCR}
${BOX_COL}|${NCR}${BLD} > Kernel:${RST} $(uname -r)${NCR}
${BOX_COL}|${NCR}${BLD} > Uptime:${RST} ${UPTIME}
${BOX_COL}|${NCR}${BLD} > DE:${RST} ${DE}
${BOX_COL}|${NCR}${BLD} > WM:${RST} ${WM}
${BOX_COL}|${NCR}${BLD} > WM Theme:${RST} ${WM_T}
${BOX_COL}|${NCR}${BLD} > Theme:${RST} ${THEME}
${BOX_COL}|${NCR}${BLD} > Icons:${RST} ${ICONS}
${BOX_COL}|${NCR}${BLD} > Terminal:${RST} $TERMINAL
${BOX_COL}|$(box.size)+${NCR}
${BOX_COL}|${NCR}${BLD} > CPU:${RST} $CPU_INFO
${BOX_COL}|${NCR}${BLD} > GPU:${RST} ${GPU}
${BOX_COL}|${NCR}${BLD} > Memory:${RST} $MEMORY_INFO
${BOX_COL}|${NCR}${BLD} > Packages:${RST} $PKG_COUNT
${BOX_COL}|$(box.size)+${NCR}
${BOX_COL}|${NCR}${BLD} > Shell:${RST} ${SHELL_INFO}
${BOX_COL}|${NCR}${BLD} > Structure:${RST} ${STRUCTURE}
${BOX_COL}|${NCR}${BLD} > Resolution${RST}: ${RES}
${BOX_COL}+$(box.size)+${NCR}
${BLD}Version 1.1.0${RST}"

#19. FINAL OUTPUT POSITIONS ----->
if [[ "$IMAGE" == *"NO IMAGE"* ]] || [ -z "$IMAGE" ]; then 
    paste <(echo -e "$IMAGE") <(echo -e "$INFO") 
else
    paste <(echo -e "${BLD}$IMAGE${RST}") <(echo -e "$INFO") 
fi
#Code configured to: Image to Left, Info to Right.

# NOTE FROM CODER ----->
#This code is made for the simplicity best, as this code, even inputted in the roots, keeps no connections with the system itself, so if you're deciding to nuke this code if not satisfied, there's no issue regarding that, tweaking is HEAVILY SUPPORTED [Especially for Arch / Arch based OS's users], Have Fun!.
