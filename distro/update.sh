#!/bin/bash

# GitHub repository details
OWNER="thisaducat"
REPO="liquid-linux"
FILE_PATH="/liquid_tmp/update.tar.xz"

REMOTE_VERSION=$(curl -s "https://raw.githubusercontent.com/thisaducat/liquid-linux/main/version/liquid.ver")
LOCAL_VERSION=$(cat /liquid/liquid.ver)

if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
  while true; do
    read -p "Güncelleme bulundu. İndirmek istiyor musunuz? [E/H] -- ($LOCAL_VERSION --> $REMOTE_VERSION) " yn
    case $yn in
        [Ee]* ) break;;
        [Hh]* ) exit;;
        * ) echo "Yanlış."; exit;;
    esac
done
  sleep 3


API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
release_info=$(wget $API_URL)
download_url=$(echo "$release_info" | grep "browser_download_url" | grep "$FILE_PATH" | cut -d '"' -f 4)
destination_path="$FILE_PATH"

wget "$download_url" -O "$destination_path"

echo "Download complete."
 

  echo "İndirme tamamlandı."
  sleep 3
  
  
  
  
  
  
  
  
  
  echo "Güncellemeler kuruluyor..."
  sleep 3
  mkdir /liquid_tmp/update
  tar -xvf /liquid_tmp/update.tar.xz -C /liquid_tmp/update/
  chmod +x /liquid_tmp/update/run
  sh /liquid_tmp/update/run


  echo "$REMOTE_VERSION" > /liquid/liquid.ver
  rm -rf /liquid_tmp/update
  clear
  
  echo "Güncelleme tamamlandı! Lütfen Liquid'i yeniden başlatın. (Yeni Sürüm: $REMOTE_VERSION)"
else
  echo "Güncelleme bulunamadı. (Güncel Sürüm: $LOCAL_VERSION)"
fi
