<p align="center">
<img src="./distro/1.png">
</p>
<p align="center">
<img src="https://img.shields.io/badge/MADE%20IN-TURKEY-white?colorA=%23ff0000&colorB=%23017e40&style=for-the-badge">
<img src="https://img.shields.io/badge/Version-1.0-blue?style=for-the-badge">
</p>
<p align="center">
<img src="https://img.shields.io/badge/Written%20In-Bash-darkgreen?style=flat-square">
<img src="https://img.shields.io/badge/Open%20Source-Yes-darkviolet?style=flat-square">
<img src="https://img.shields.io/github/stars/thisaducat/liquid-linux?style=flat-square">
<img src="https://img.shields.io/github/issues/thisaducat/liquid-linux?color=red&style=flat-square">
<img src="https://img.shields.io/github/forks/thisaducat/liquid-linux?color=teal&style=flat-square">
</p>
<p align="center"><b>Termux için Sanal Ortam</b></p>

### NOT: LİQUİD HALA YAPIM AŞAMASINDA EĞER HATALAR BULUNUYORSA VEYA ÖNERİLERİNİZ VAR İSE MUTLAKA BENİMLE İLETİŞİME GEÇ :)
## Discord: whycat#7306

### Özellikleri

- Grafik hızlandırması bulunuyor. (Hardware Acceleration [3D]-[X11])
- Ses Desteği Bulunuyor (Masaüstü ortamı ile)
- Hafif {En az 4GB Alanınızın bulunması gerekiyor(Masaüstü ortamı ile) }
- Font Desteği var
- Yeni başlayan Kullanıcılar için

### Kurulum
- İlk önce Termux indirmeniz gerekiyor. [BURADAN İNDİRİN](https://f-droid.org/repo/com.termux_118.apk) (Play Store'de bulunan sorunlu)
- Daha sonra masaüstü ortamını grafik hızlandırıcısını kullanarak görüntülemek için Termux:x11 yüklemeniz gerekiyor. [BURADAN İNDİRİN](https://github.com/termux/termux-x11/releases/tag/nightly)
- Termux'a girin kurulum dosyalarını indirin & Kurulum dosyasını çalıştırın.
  - `apt update`
  - `apt install git wget ncurses-utils -y`
  - `git clone --depth=1 https://github.com/thisaducat/liquid-linux.git`
  - `cd liquid-linux`
  - `chmod +x *`
  - `./kur`

- Kurulduktan sonra `liquid` yazarak sanal ortama giriş yapın ve şunları yazın:

   - `liquid`
   - `set-liquid`

- Kullanıcı Adı ve Şifresi girin [Küçük harflerle & Boşluk kullanmadan]

- Kurulum tamamlandığında Liquid'i yeniden başlatın. Şuanda hazır sayılırsınız. Eğer masaüstü ortamı kurmak istiyorsanız aşağıdaki komutu yazın:

- `set-gui`

- Kurulum sırasında masaüstü ortamı seçme ekranında masaüstü ortamını yükledikten sonra tekrar masaüstü seçme ekranına atacaktır. Yön tuşları ile `cancel` demeniz gerekiyor. Bu bir bug değil. (Çoklu masaüstü ortamı kullanabilirsiniz.) 
- Masaüstü ortamını kullanmak `libaslat` yazıp istediğiniz masaüstü ortamını seçmeniz gerekecek. Seçtikten sonra değişik yazılar yazmaya başlayacak korkmanıza gerek yok bu sadece masaüstünün çalıştığını gösterir.

Örneğin;
<img src="./distro/gnome.png">
Bu GNOME masaüstü ortamını başlatırken çıkan yazı. Bu yazıların benzeri XFCE4 ve ICEWM masaüstü ortamlarındada oluyor.
  

### NOT :

ÖNEMLİ: Kurulum, masaüstü ortamını seçip yükledikten sonra tekrar masaüstü ortamı seçme kısmına atıyor oradan yön tuşlarını kullanıp "cancel" demeniz gerekiyor. Dialog komutunundan dolayı kaynaklanmaktadır. 



- **Liquid'i güncellemek için `update` komutunu kullanın.**

- **Kaldırmak için `./sil` komutunu yazın.**


#
Licensed under [Apache License](./LICENSE)
#

### Yapımcı

- [**Aducat (whycat)**](https://github.com/thisaducat)


### Çalışmamı beğendiysen lütfen yıldız bırak :)

