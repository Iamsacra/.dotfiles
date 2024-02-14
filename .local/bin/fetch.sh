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
if [ -x "$(command -v dpkg)" ]; then
    packages=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
elif [ -x "$(command -v rpm)" ]; then
    packages=$(rpm -qa | wc -l)
elif [ -x "$(command -v pacman)" ]; then
    packages=$(pacman -Qq | wc -l)
elif [ -x "$(command -v emerge)" ]; then
    packages=$(qlist -I | wc -l)
else
    packages="Unknown"
fi

# Print
echo "╭─"
echo "│           ${bold}Software${normal}"
echo "│ ➔ ${bold}Uptime${normal}    $uptime"
echo "│ ➔ ${bold}OS${normal}        $os"
echo "│ ➔ ${bold}Kernel${normal}    $kernel"
echo "│ ➔ ${bold}Shell${normal}     $shell"
echo "│ ➔ ${bold}Packages${normal}  $packages"
echo "│                                   "
echo "│           ${bold}Hardware${normal}"
echo "│ ➔ ${bold}Memory${normal}    $memory_used MB / $memory_total MB"
echo "│ ➔ ${bold}Disk${normal}      $disk"
echo "╰─"
