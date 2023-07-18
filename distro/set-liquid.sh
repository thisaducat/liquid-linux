#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"

banner() {

		cat <<- EOF
		${Y}    ------------------------
		${C}    |     Liquid-Linux     |
		${G}    ------------------------
	EOF

}

sudo() {
    echo -e "\n${R} [${W}-${R}]${C} Installing Sudo..."${W}
    apt update -y
    apt install sudo -y
    apt install wget apt-utils locales-all dialog tzdata -y
    echo -e "\n${R} [${W}-${R}]${G} Sudo Successfully Installed !"${W}

}

login() {
    banner
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Username [Lowercase] : \e[0m\e[1;96m\en' user
    echo -e "${W}"
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Input Password : \e[0m\e[1;96m\en' pass
    echo -e "${W}"
    useradd -m -s $(which bash) ${user}
    usermod -aG sudo ${user}
    echo "${user}:${pass}" | chpasswd
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    cp /root/.bashrc /home/$user/.bashrc
    echo "proot-distro login --user $user liquid --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports" > /data/data/com.termux/files/usr/bin/liquid
    chmod +x /data/data/com.termux/files/usr/bin/liquid
    
    if [[ -e '/data/data/com.termux/files/home/linux-distro/distro/gui.sh' ]];then
        cp /data/data/com.termux/files/home/linux-distro/distro/gui.sh /bin/continue-last
        chmod +x /bin/continue-last
    else
        wget -q --show-progress https://raw.githubusercontent.com/thisaducat/linux-liquid/master/distro/gui.sh
        mv -vf gui.sh /bin/continue-last
        chmod +x /bin/continue-last
    fi

    clear
    echo
    echo -e "\n${R} [${W}-${R}]${G} Restart Liquid & Type ${C}continue-last"${W}
    echo

}

banner
sudo
login
