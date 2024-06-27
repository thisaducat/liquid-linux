import sys
import os
import subprocess
from PyQt5.QtWidgets import QApplication, QWidget, QVBoxLayout, QToolButton, QGridLayout, QStackedWidget
from PyQt5.QtGui import QIcon, QFont, QImage, QPixmap, QBrush
from PyQt5.QtCore import Qt, QSize

class NoFocusButton(QToolButton):
    def __init__(self, parent=None):
        super().__init__(parent)
        self.setAutoFillBackground(True)  # Arka planı otomatik olarak doldur
        self.setStyleSheet('''
            QToolButton {
                background-color: transparent;
                border: none;
                padding: 0px;
                margin: 0px;
                text-align: center;
            }
            QToolButton::menu-indicator {
                image: none;
            }
        ''')

class AppLauncher(QWidget):
    def __init__(self):
        super().__init__()
        self.initUI()

    def initUI(self):
        self.setWindowTitle('App Launcher')
        self.setGeometry(100, 100, 800, 600)
        self.setWindowFlags(Qt.FramelessWindowHint)  # Pencere kontrollerini kaldır

        # Arka planı siyah yap
        self.setStyleSheet("background-color: black; color: white;")

        self.stackedLayout = QStackedWidget()

        self.populateAppPages()

        # Ana düzen oluştur
        mainLayout = QVBoxLayout()
        mainLayout.addWidget(self.stackedLayout)
        self.setLayout(mainLayout)  # Ana düzeni ayarla

        # Sol alt köşeye ileri ve geri butonlarını ekle
        self.addNavigationButtons()

        # Sağ alt köşeye kapatma ve minimize butonlarını ekle
        self.addCloseMinimizeButtons()

        self.showFullScreen()  # Tam ekran modunda çalıştır
        self.show()

    def setBackgroundImage(self, image_path):
        palette = self.palette()
        image = QImage(image_path)
        palette.setBrush(self.backgroundRole(), QBrush(image))
        self.setPalette(palette)

    def populateAppPages(self):
        desktop_files_dir = '/usr/share/applications'
        apps = []
        for filename in os.listdir(desktop_files_dir):
            if filename.endswith('.desktop'):
                desktop_entry = self.parseDesktopFile(os.path.join(desktop_files_dir, filename))
                if desktop_entry:
                    apps.append(desktop_entry)
        
        page_layout = QGridLayout()
        page_widget = QWidget()
        page_widget.setLayout(page_layout)
        self.stackedLayout.addWidget(page_widget)

        row, col = 0, 0
        for i, app in enumerate(apps):
            icon_path = app.get('Icon', 'application-x-executable')
            app_button = NoFocusButton()
            app_button.setIcon(QIcon.fromTheme(icon_path))
            app_button.setIconSize(QSize(64, 64))  # İkon boyutunu ayarlamak için QSize kullan
            app_button.setToolButtonStyle(Qt.ToolButtonTextUnderIcon)  # Metni ikonun altına yerleştir
            app_button.setFont(QFont('Arial', 10))  # Yazı fontunu ayarla
            app_button.setText(app['Name'])  # Düğme metnini ayarla
            app_button.setFixedSize(100, 100)  # Düğme boyutunu ayarla
            app_button.clicked.connect(lambda _, a=app['Exec']: self.launchApp(a))
            page_layout.addWidget(app_button, col, row, Qt.AlignCenter)  # İkonları ve metinleri merkezi olarak hizala

            row += 1
            if row >= 6:
                row = 0
                col += 1
            if col >= 5:
                page_layout = QGridLayout()
                page_widget = QWidget()
                page_widget.setLayout(page_layout)
                self.stackedLayout.addWidget(page_widget)
                row, col = 0, 0

    def parseDesktopFile(self, filepath):
        desktop_entry = {}
        with open(filepath, 'r') as f:
            for line in f:
                if line.startswith('Name='):
                    desktop_entry['Name'] = line.strip().split('=', 1)[1]
                elif line.startswith('Exec='):
                    desktop_entry['Exec'] = line.strip().split('=', 1)[1]
                elif line.startswith('Icon='):
                    desktop_entry['Icon'] = line.strip().split('=', 1)[1]
        return desktop_entry

    def launchApp(self, app_exec):
        subprocess.Popen(app_exec.split())

    def addNavigationButtons(self):
        navLayout = QVBoxLayout()
        navLayout.setAlignment(Qt.AlignBottom | Qt.AlignLeft)  # Sol alt köşe hizalaması

        prev_btn = NoFocusButton(self)
        prev_btn.setIcon(QIcon.fromTheme('go-previous'))
        prev_btn.setIconSize(QSize(48, 48))
        prev_btn.clicked.connect(self.prevPage)
        navLayout.addWidget(prev_btn)

        next_btn = NoFocusButton(self)
        next_btn.setIcon(QIcon.fromTheme('go-next'))
        next_btn.setIconSize(QSize(48, 48))
        next_btn.clicked.connect(self.nextPage)
        navLayout.addWidget(next_btn)

        self.layout().addLayout(navLayout)

    def addCloseMinimizeButtons(self):
        close_minimize_layout = QVBoxLayout()
        close_minimize_layout.setAlignment(Qt.AlignBottom | Qt.AlignLeft)  # Sol alt köşe hizalaması

        close_btn = NoFocusButton(self)
        close_btn.setText('Close')
        close_btn.setToolButtonStyle(Qt.ToolButtonTextUnderIcon)  # Metni ikonun altına yerleştir
        close_btn.setIcon(QIcon.fromTheme('application-exit'))
        close_btn.setIconSize(QSize(48, 48))
        close_btn.clicked.connect(self.closeApp)
        close_minimize_layout.addWidget(close_btn)

        minimize_btn = NoFocusButton(self)
        minimize_btn.setText('Minimize')
        minimize_btn.setToolButtonStyle(Qt.ToolButtonTextUnderIcon)  # Metni ikonun altına yerleştir
        minimize_btn.setIcon(QIcon.fromTheme('view-sort-ascending'))
        minimize_btn.setIconSize(QSize(48, 48))
        minimize_btn.clicked.connect(self.showMinimized)
        close_minimize_layout.addWidget(minimize_btn)

        self.layout().addLayout(close_minimize_layout)

    def prevPage(self):
        current_index = self.stackedLayout.currentIndex()
        if current_index > 0:
            self.stackedLayout.setCurrentIndex(current_index - 1)

    def nextPage(self):
        current_index = self.stackedLayout.currentIndex()
        if current_index < self.stackedLayout.count() - 1:
            self.stackedLayout.setCurrentIndex(current_index + 1)

    def closeApp(self):
        self.close()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    app.setStyle('Fusion')  # Fusion tema ayarla
    ex = AppLauncher()
    sys.exit(app.exec_())
