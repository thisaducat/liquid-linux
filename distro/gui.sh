#!/bin/bash

R="$(printf '\033[1;31m')"
G="$(printf '\033[1;32m')"
Y="$(printf '\033[1;33m')"
W="$(printf '\033[1;37m')"
C="$(printf '\033[1;36m')"
arch=$(uname -m)
username=$(getent group sudo | awk -F ':' '{print $4}' | cut -d ',' -f1)

check_root(){
	if [ "$(id -u)" -ne 0 ]; then
		echo -ne " ${R}Bu komut root izni gerektiriyor!\n\n"${W}
		exit 1
	fi
}

banner() {
	clear
	cat <<- EOF
		${Y}    ------------------------
		${C}    |     Liquid-Linux     |
		${G}    ------------------------
	EOF
	
}

note() {
	banner
	echo -e " ${G} [-] Masaüstü ortamı Başarılı bir şekilde kuruldu !\n"${W}
	sleep 1
	cat <<- EOF
		 ${G}[-] Masaüstü ortamını başlatmak için ${C}libaslat${G} yazın.
                 ${G}[-] Grafik hızlandırılmış masaüstü ortamını başlatmak için ${C}libaslat3d${G} yazın.
		 ${G}[-] Masaüstü ortamını kapatmak için ${C}likapat${G} yazın.

		 ${C}Masaüstü ortamının tadını çıkar :)${W}
	EOF
}

select_environment(){
items=(1 "xfce4 (Normal)"
       2 "icewm (Hafif)"
       3 "Hepsi (Yüksek depolama gerektirir)"
       )

while choice=$(dialog --title "Masaüstü KUR" \
                 --menu "Lütfen kurmak istediğiniz masaüstünü seçin." 10 40 3 "${items[@]}" \
                 2>&1 >/dev/tty)
    do
    case $choice in
        1) package;;
        2) package_icewm;;
	3) package_all;;
        *) clear; exit;;
    esac
done
clear
}

package_icewm() {
banner
	echo -e "${R} [${W}-${R}]${C} Paketler kontrol ediliyor.."${W}
	apt-get update -y
	apt install udisks2 -y
	rm /var/lib/dpkg/info/udisks2.postinst
	echo "" > /var/lib/dpkg/info/udisks2.postinst
	dpkg --configure -a
	apt-mark hold udisks2
	
	packs=(sudo icewm gnupg2 curl nano git xz-utils at-spi2-core librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Şu paket kuruluyor : ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	apt-get update -y
	apt-get upgrade -y
}

package_all() {
banner
	echo -e "${R} [${W}-${R}]${C} Paketler kontrol ediliyor.."${W}
	apt-get update -y
	apt install udisks2 -y
	rm /var/lib/dpkg/info/udisks2.postinst
	echo "" > /var/lib/dpkg/info/udisks2.postinst
	dpkg --configure -a
	apt-mark hold udisks2
	
	packs=(sudo icewm gnupg2 curl nano git xz-utils at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Şu paket kuruluyor : ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	apt-get update -y
	apt-get upgrade -y
}


package() {
	banner
	echo -e "${R} [${W}-${R}]${C} Paketler kontrol ediliyor.."${W}
	apt-get update -y
	apt install udisks2 -y
	rm /var/lib/dpkg/info/udisks2.postinst
	echo "" > /var/lib/dpkg/info/udisks2.postinst
	dpkg --configure -a
	apt-mark hold udisks2
	
	packs=(sudo gnupg2 curl nano git xz-utils at-spi2-core xfce4 xfce4-goodies xfce4-terminal librsvg2-common menu inetutils-tools dialog exo-utils tigervnc-standalone-server tigervnc-common tigervnc-tools dbus-x11 fonts-beng fonts-beng-extra gtk2-engines-murrine gtk2-engines-pixbuf apt-transport-https)
	for hulu in "${packs[@]}"; do
		type -p "$hulu" &>/dev/null || {
			echo -e "\n${R} [${W}-${R}]${G} Şu paket kuruluyor : ${Y}$hulu${W}"
			apt-get install "$hulu" -y --no-install-recommends
		}
	done
	
	apt-get update -y
	apt-get upgrade -y
}

install_apt() {
	for apt in "$@"; do
		[[ `command -v $apt` ]] && echo "${Y}${apt} bu paket zaten kurulu!${W}" || {
			echo -e "${G}İndiriliyor: ${Y}${apt}${W}"
			apt install -y ${apt}
		}
	done
}

install_vscode() {
	[[ $(command -v code) ]] && echo "${Y}VSCode zaten yüklü!${W}" || {
		echo -e "${G}Yükleniyor: ${Y}VSCode${W}"
		curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
		apt update -y
		apt install code -y
		echo "Yamalanıyor.!."
		wget https://raw.githubusercontent.com/thisaducat/liquid-linux/master/distro/VSCode.desktop > /usr/share/applications/VSCode.desktop
		echo -e "${C} Visual Studio Code Başarıyla yüklendi!\n${W}"
	}
}

install_sublime() {
	[[ $(command -v subl) ]] && echo "${Y}Sublime Text zaten kurulu!${W}" || {
		apt install gnupg2 software-properties-common --no-install-recommends -y
		echo "deb https://download.sublimetext.com/ apt/stable/" | tee /etc/apt/sources.list.d/sublime-text.list
		curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/sublime.gpg 2> /dev/null
		apt update -y
		apt install sublime-text -y 
		echo -e "${C} Sublime Text Editor Başarıyla yüklendi!\n${W}"
	}
}

install_chromium() {
	[[ $(command -v chromium) ]] && echo "${Y}Chromium zaten yüklü!${W}\n" || {
		echo -e "${G}Kuruluyor: ${Y}Chromium${W}"
		apt purge chromium* chromium-browser* snapd -y
		apt install gnupg2 software-properties-common --no-install-recommends -y
		echo -e "deb http://ftp.debian.org/debian buster main\ndeb http://ftp.debian.org/debian buster-updates main" >> /etc/apt/sources.list
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DCC9EFBF77E11517
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AA8E81B4331F7F50
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
		apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
		apt update -y
		apt install chromium -y
		sed -i 's/chromium %U/chromium --no-sandbox %U/g' /usr/share/applications/Chromium.desktop
		echo -e "${G} Chromium Başarıyla yüklendi!\n${W}"
	}
}

install_firefox() {
	[[ $(command -v firefox) ]] && echo "${Y}Firefox zaten yüklü!${W}\n" || {
		echo -e "${G}Kuruluyor: ${Y}Firefox${W}"
		bash <(curl -fsSL "https://raw.githubusercontent.com/thisaducat/liquid-linux/master/distro/firefox.sh")
		echo -e "${G} Firefox Başarıyla kuruldu!\n${W}"
	}
}

install_softwares() {
	banner
	cat <<- EOF
		${Y} ---${G} İnternet Tarayıcı ${Y}---

		${C} [${W}1${C}] Firefox (Varsayılan)
		${C} [${W}2${C}] Chromium
		${C} [${W}3${C}] Hepsi (Firefox + Chromium)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} ?: ${G}" BROWSER_OPTION
	banner

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		cat <<- EOF
			${Y} ---${G} Metin Düzenleyici ${Y}---

			${C} [${W}1${C}] Sublime Text Editor (Önerilen)
			${C} [${W}2${C}] Visual Studio Code (Cihazınızın mimarisiyle uyumsuz olabilir!)
			${C} [${W}3${C}] Hepsi (Sublime + VSCode)
			${C} [${W}4${C}] Hiçbirisi (Varsayılan)

		EOF
		read -n1 -p "${R} [${G}~${R}]${Y} ?: ${G}" IDE_OPTION
		banner
	}
	
	cat <<- EOF
		${Y} ---${G} Media Oynatıcı ${Y}---

		${C} [${W}1${C}] MPV Media Player 
		${C} [${W}2${C}] VLC Media Player (Önerilen)
		${C} [${W}3${C}] Hepsi (MPV + VLC)
		${C} [${W}4${C}] Hiçbirisi (Varsayılan)

	EOF
	read -n1 -p "${R} [${G}~${R}]${Y} ?: ${G}" PLAYER_OPTION
	{ banner; sleep 1; }

	if [[ ${BROWSER_OPTION} == 2 ]]; then
		install_chromium
	elif [[ ${BROWSER_OPTION} == 3 ]]; then
		install_firefox
		install_chromium
	else
		install_firefox
	fi

	[[ ("$arch" != 'armhf') || ("$arch" != *'armv7'*) ]] && {
		if [[ ${IDE_OPTION} == 1 ]]; then
			install_sublime
		elif [[ ${IDE_OPTION} == 2 ]]; then
			install_vscode
		elif [[ ${IDE_OPTION} == 3 ]]; then
			install_sublime
			install_vscode
		else
			echo -e "${Y} [!] Metin düzenleyici kurulumu atlandı!\n"
			sleep 1
		fi
	}

	if [[ ${PLAYER_OPTION} == 1 ]]; then
		install_apt "mpv"
	elif [[ ${PLAYER_OPTION} == 2 ]]; then
		install_apt "vlc"
	elif [[ ${PLAYER_OPTION} == 3 ]]; then
		install_apt "mpv" "vlc"
	else
		echo -e "${Y} [!] Medya oynatıcı kurulumu atlandı!\n"
		sleep 1
	fi

}

downloader(){
	path="$1"
	[[ -e "$path" ]] && rm -rf "$path"
	echo "Yükleniyor: $(basename $1)..."
	curl --progress-bar --insecure --fail \
		 --retry-connrefused --retry 3 --retry-delay 2 \
		  --location --output ${path} "$2"
}

sound_fix() {
	echo "$(echo "bash ~/.sound" | cat - /data/data/com.termux/files/usr/bin/liquid)" > /data/data/com.termux/files/usr/bin/liquid
	echo "export DISPLAY=":1"" >> /etc/profile
	echo "export PULSE_SERVER=127.0.0.1" >> /etc/profile 
	source /etc/profile
}

rem_theme() {
	theme=(Bright Daloa Emacs Moheli Retro Smoke)
	for rmi in "${theme[@]}"; do
		type -p "$rmi" &>/dev/null || {
			rm -rf /usr/share/themes/"$rmi"
		}
	done
}

rem_icon() {
	fonts=(hicolor LoginIcons ubuntu-mono-light)
	for rmf in "${fonts[@]}"; do
		type -p "$rmf" &>/dev/null || {
			rm -rf /usr/share/icons/"$rmf"
		}
	done
}

config() {
	banner
	sound_fix

	if which xfce4-session >/dev/null; then
    echo "xfce4 bulundu tema kuruluyor"
	apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
	yes | apt upgrade
	yes | apt install gtk2-engines-murrine gtk2-engines-pixbuf sassc optipng inkscape libglib2.0-dev-bin
	mv -vf /usr/share/backgrounds/xfce/xfce-verticals.png /usr/share/backgrounds/xfce/xfceverticals-old.png
	temp_folder=$(mktemp -d -p "$HOME")
	{ banner; sleep 1; cd $temp_folder; }

	echo -e "${R} [${W}-${R}]${C} Gerekli dosyalar indiriliyor..\n"${W}
	downloader "fonts.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/fonts.tar.gz"
	downloader "icons.tar.gz" "https://github.com/thisaducat/liquid-linux/releases/download/Liquid-DATA/icons.tar.gz"
	downloader "wallpaper.tar.gz" "https://github.com/modded-ubuntu/modded-ubuntu/releases/download/config/wallpaper.tar.gz"
	downloader "gtk.tar.gz" "https://github.com/thisaducat/liquid-linux/releases/download/Liquid-DATA/gtk.tar.gz"
	downloader "liquid-set.tar.gz" "https://github.com/thisaducat/liquid-linux/releases/download/Liquid-DATA/liquid-set.tar.gz"

	echo -e "${R} [${W}-${R}]${C} Unpacking Files..\n"${W}
	tar -xvzf fonts.tar.gz -C "/usr/local/share/fonts/"
	tar -xvzf icons.tar.gz -C "/usr/share/icons/"
	tar -xvzf wallpaper.tar.gz -C "/usr/share/backgrounds/xfce/"
	tar -xvzf gtk.tar.gz -C "/usr/share/themes/"
	tar -xvzf liquid-set.tar.gz -C "/home/$username/"	
	rm -fr $temp_folder
        else
    echo "xfce4 bulunamadı. Atlanıyor..."
fi
	echo -e "${R} [${W}-${R}]${C} Gereksiz dosyalar parçalanıyor.."${W}
	rem_theme
	rem_icon

	echo -e "${R} [${W}-${R}]${C} Yazı tipi önbelleği yeniden oluşturuyor..\n"${W}
	fc-cache -fv

	echo -e "${R} [${W}-${R}]${C} Paketler güncelleniyor..\n"${W}
	apt update
	yes | apt upgrade
	apt clean
	yes | apt autoremove

}

# ----------------------------

check_root
select_environment
install_softwares
config
note

