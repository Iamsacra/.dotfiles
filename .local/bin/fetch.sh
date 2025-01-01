#!/bin/sh

# Define text styles
bold=$(tput bold)
normal=$(tput sgr0)

# Fetch system information

# Username
username=$(whoami)
machine=$(hostname)

# Uptime
uptime=$(uptime -p)

# OS
os=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)

# Memory
memory_used=$(free -m | awk 'NR==2{print $3}')
memory_total=$(free -m | awk 'NR==2{print $2}')

# Disk
disk=$(df -h --output=used,size,pcent / | awk 'NR==2{print $1"/"$2" ("$3")"}')

# Kernel
kernel=$(uname -r)

# Get default shell
shell=$(basename "$SHELL")

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

colored_circles="\\033[0;30m  ●\\033[0m \\033[0;31m  ●\\033[0m \\033[0;32m  ●\\033[0m \\033[0;33m  ●\\033[0m \\033[0;34m  ●\\033[0m \\033[0;35m  ●\\033[0m \\033[0;36m  ●\\033[0m \\033[0;37m  ●\\033[0m"
# System info block
system_info=$(cat <<EOF
╭─
│           ${bold}Info${normal}
│ ➔ ${bold}Username${normal}    $username
│ ➔ ${bold}Machine${normal}     $machine
│                                   
│           ${bold}Software${normal}
│ ➔ ${bold}Uptime${normal}    $uptime
│ ➔ ${bold}OS${normal}        $os
│ ➔ ${bold}Kernel${normal}    $kernel
│ ➔ ${bold}Shell${normal}     $shell
│ ➔ ${bold}Packages${normal}  $packages
│                                   
│           ${bold}Hardware${normal}
│ ➔ ${bold}Memory${normal}    $memory_used MB / $memory_total MB
│ ➔ ${bold}Disk${normal}      $disk
╰─
$colored_circles
EOF
)

# Fetch Pokémon art and reset colors
pokemon_art=$(pokemon-colorscripts --no-title -rn blacephalon,golem,rapidash,lurantis,orbeetle,porygon-z,blaziken,blissey,magmar,tyrantrum,omastar,mr-mime,miltank,nidoking,wailord | sed 's/$/\x1b[0m/')

echo "$pokemon_art" > /tmp/pokemon_art.txt
echo "$system_info" > /tmp/system_info.txt

paste /tmp/pokemon_art.txt /tmp/system_info.txt

rm /tmp/pokemon_art.txt /tmp/system_info.txt

