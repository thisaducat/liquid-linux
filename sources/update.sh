#!/bin/bash

OWNER="thisaducat"
REPO="liquid-linux"
FILE_PATH="/liquid_tmp/update.tar.xz"
API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"
REMOTE_VERSION=$(curl -s "https://github.com/thisaducat/liquid-linux/version/liquid.ver")
LOCAL_VERSION=$(cat /liquid/liquid.ver)

if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
  echo "Güncelleme bulundu! İndiriliyor.. ($LOCAL_VERSION --> $REMOTE_VERSION)"
  mkdir /liquid_tmp
  mkdir /liquid_tmp/update
  touch /liquid_tmp/update.tar.xz
  sleep 3


  release_info=$(curl -s $API_URL)

  download_url=$(echo "$release_info" | grep "browser_download_url" | grep "$FILE_PATH" | cut -d '"' -f 4)

  destination_path="$FILE_PATH"


  curl -sLJO "$download_url" -o "$destination_path"

  echo "İndirme tamamlandı."
  sleep 3
  
  
  
  
  
  
  
  
  
  echo "Güncellemeler kuruluyor..."
  sleep 3
  tar -xvf /liquid_tmp/update.tar.xz -C /liquid_tmp/update/
  chmod +x /liquid_tmp/update/run
  sh /liquid_tmp/update/run


  echo "$REMOTE_VERSION" > /liquid/liquid.ver
  rm -rf /liquid_tmp/update
  clear
  
  echo "Güncelleme tamamlandı! Lütfen Liquid'i yeniden başlatın. (Sürüm: $LOCAL_VERSION)"
else
  echo "Güncelleme bulunamadı. (Sürüm: $LOCAL_VERSION)"
fi
