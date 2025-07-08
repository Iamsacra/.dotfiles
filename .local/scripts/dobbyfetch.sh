#!/bin/sh

bold=$(tput bold)
normal=$(tput sgr0)

# Fetch system information

# Username
username=$(whoami)
machine=$(hostname)

# Uptime
uptime=$(uptime -p)

# OS
os=$(cat /etc/os-release | grep PRETTY_NAME | cut -d'"' -f2)

# Memory
memory_used=$(free -m | awk 'NR==2{print $3}')
memory_total=$(free -m | awk 'NR==2{print $2}')

# Disk
disk=$(df -h --output=used,size,pcent / | awk 'NR==2{print $1"/"$2" ("$3")"}')

# Kernel
kernel=$(uname -r)

# Get default shell
shell=$(basename $SHELL)

# Package manager
if command -v apt >/dev/null 2>&1; then
    packages=$(apt list --installed 2>/dev/null | wc -l)
elif command -v rpm >/dev/null 2>&1; then
    packages=$(rpm -qa | wc -l)
elif command -v pacman >/dev/null 2>&1; then
    packages=$(pacman -Qq | wc -l)
elif command -v emerge >/dev/null 2>&1; then
    packages=$(qlist -I | wc -l)
else
    packages="Unknown"
fi

# Print
echo "   _____       ╭─"
echo "  /     \      │           ${bold}Info${normal}"
echo "/- (*) |*)\    │ ➔ ${bold}Username${normal}    $username"
echo "|/\.  _>/\|    │ ➔ ${bold}Machine${normal}     $machine"
echo "    \__/    |\ │                                   "
echo "   _| |_   \-/ │           ${bold}Software${normal}"
echo "  /|\__|\  //  │ ➔ ${bold}Uptime${normal}    $uptime"
echo " |/|   |\//    │ ➔ ${bold}OS${normal}        $os"
echo " |||   | ~'    │ ➔ ${bold}Kernel${normal}    $kernel"
echo " ||| __|       │ ➔ ${bold}Shell${normal}     $shell"
echo " /_\| ||       │ ➔ ${bold}Packages${normal}  $packages"
echo " \_/| ||       │                                   "
echo "   |7 |7       │           ${bold}Hardware${normal}"
echo "   || ||       │ ➔ ${bold}Memory${normal}    $memory_used MB / $memory_total MB"
echo "   || ||       │ ➔ ${bold}Disk${normal}      $disk"
echo "   /\ \ \  fog ╰─"
echo "  ^^^^ ^^^      "