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

liquid_repo(){
echo "deb [trusted=yes] https://thisaducat.github.io/liquid-repo main/" >> /etc/apt/sources.list
}

sudo() {
    echo -e "\n${R} [${W}-${R}]${C} Kuruluyor: sudo"${W}
    apt update -y
    apt install sudo -y
    apt install wget apt-utils locales-all dialog tzdata ca-certificates -y
    echo -e "\n${R} [${W}-${R}]${G} Sudo Kuruldu !"${W}

}

update() {
    echo -e "\n${R} [${W}-${R}]${C} Kuruluyor: update (Liquid Update)"${W}
    apt update -y
    apt install liquid-update curl
    echo -e "\n${R} [${W}-${R}]${G} Update komutu kuruldu !"${W}
}

login() {
    banner
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Kullanıcı Adı [küçük harflerle] : \e[0m\e[1;96m\en' user
    echo -e "${W}"
    read -p $' \e[1;31m[\e[0m\e[1;77m~\e[0m\e[1;31m]\e[0m\e[1;92m Kullanıcı Şifresi : \e[0m\e[1;96m\en' pass
    echo -e "${W}"
    useradd -m -s $(which bash) ${user}
    usermod -aG sudo ${user}
    echo "${user}:${pass}" | chpasswd
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers
    rm /data/data/com.termux/files/usr/bin/liquid
    echo "proot-distro login --user $user liquid --bind /dev/null:/proc/sys/kernel/cap_last_last --shared-tmp --fix-low-ports --no-sysvipc" >> /data/data/com.termux/files/usr/bin/liquid
    chmod +x /data/data/com.termux/files/usr/bin/liquid
    mkdir "/home/$user/.config"
    cp "/data/data/com.termux/files/home/liquid-linux/distro/logo" "/liquid/logo"
    cp "/data/data/com.termux/files/home/liquid-linux/distro/boot" "/liquid/boot"
    echo "sleep 2" > "/data/data/com.termux/files/home/.bashrc"
    echo "termux-x11 :0 >/dev/null &" >> "/data/data/com.termux/files/home/.bashrc"
    echo "sleep 1" >> "/data/data/com.termux/files/home/.bashrc"
    echo "clear" >> "/home/$user/.bashrc"
    echo "/liquid/boot" >> "/home/$user/.bashrc"
    chmod +x "/liquid/boot"
    
    if [[ -e '/data/data/com.termux/files/home/linux-distro/distro/gui.sh' ]];then
        cp /data/data/com.termux/files/home/liquid-linux/distro/gui.sh /bin/set-gui
        chmod +x /bin/set-gui
    else
        wget -q --show-progress https://raw.githubusercontent.com/thisaducat/liquid-linux/master/distro/gui.sh
        mv -vf gui.sh /bin/set-gui
        chmod +x /bin/set-gui
    fi

    clear
    echo
    echo -e "\n${R} [${W}-${R}]${G} Kurulum tamamlandı! Lütfen Liquid'i yeniden başlatın. Eğer masaüstü ortamını kurmak istiyorsanız yeniden başlattıktan sonra ${R}set-gui ${G}yazın."${W}
    echo

}

banner
sudo
liquid_repo
update
login
