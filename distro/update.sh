#!/bin/bash
REMOTE_VERSION=$(curl -s "https://raw.githubusercontent.com/thisaducat/liquid-linux/main/version/liquid.ver")
LOCAL_VERSION=$(cat /liquid/liquid.ver)

if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
  echo "Güncelleme bulundu! İndiriliyor.. ($LOCAL_VERSION --> $REMOTE_VERSION)"
  sleep 3

  curl -s "https://github.com/thisaducat/liquid-linux/releases/download/Li-Update/update.tar.xz" -o /liquid_tmp/updates.tar.xz
 

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
