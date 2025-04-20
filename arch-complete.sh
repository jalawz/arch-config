#!/bin/bash

set -e

# Função para instalar o ambiente gráfico
install_desktop_env() {
  desktop=$(whiptail --title "Ambiente Gráfico" \
    --radiolist "Escolha o ambiente gráfico para instalar:" 15 60 2 \
    "GNOME" "Ambiente GNOME Completo" ON \
    "KDE" "Ambiente KDE Plasma" OFF 3>&1 1>&2 2>&3)

  case $desktop in
    GNOME)
      echo "Instalando GNOME..."
      sudo pacman -S --noconfirm gnome gnome-extra gdm
      sudo systemctl enable gdm
      ;;
    KDE)
      echo "Instalando KDE Plasma..."
      sudo pacman -S --noconfirm plasma kde-applications sddm
      sudo systemctl enable sddm
      ;;
  esac
}

# Instalar yay (AUR helper)
install_yay() {
  echo "Instalando yay (AUR helper)..."
  sudo pacman -S --noconfirm git base-devel
  if [ ! -d /tmp/yay ]; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
  fi
}

# Instalar ZSH e Oh My Zsh
install_zsh() {
  echo "Instalando ZSH e Oh My Zsh..."
  sudo pacman -S --noconfirm zsh
  chsh -s /bin/zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Instalar ferramentas de desenvolvimento
install_dev_tools() {
  echo "Instalando ferramentas de desenvolvimento..."
  sudo pacman -S --noconfirm git curl wget unzip zip python-pip

  echo "Instalando SDKMAN..."
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"

  echo "Instalando NVM..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

  echo "Instalando virtualenvwrapper..."
  pip install --user virtualenvwrapper

  echo "Configurando virtualenvwrapper no ~/.zshrc..."
  cat <<EOF >> "$HOME/.zshrc"
# Virtualenvwrapper
export WORKON_HOME=\$HOME/.virtualenvs
export PROJECT_HOME=\$HOME/Devel
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source \$HOME/.local/bin/virtualenvwrapper.sh
EOF
}

# Instalar utilitários gerais
install_utils() {
  echo "Instalando utilitários gerais..."
  sudo pacman -S --noconfirm networkmanager xorg xorg-xinit \
    ttf-dejavu ttf-liberation ttf-droid noto-fonts noto-fonts-emoji ttf-ms-fonts \
    alsa-utils pulseaudio pulseaudio-alsa pavucontrol \
    mesa lib32-mesa vulkan-intel xf86-video-intel \
    nano htop neofetch
  sudo systemctl enable NetworkManager
  sudo systemctl start NetworkManager
}

main_menu() {
  OPTIONS=(1 "Instalar Ambiente Gráfico"
           2 "Instalar yay (AUR helper)"
           3 "Instalar ZSH + Oh My Zsh"
           4 "Instalar Ferramentas de Desenvolvimento"
           5 "Instalar Utilitários Gerais")

  CHOICES=$(whiptail --title "Pós-Instalação Arch Linux" \
    --checklist "Escolha os componentes que deseja instalar:" 20 78 10 \
    "1" "Ambiente Gráfico" ON \
    "2" "yay (AUR helper)" ON \
    "3" "ZSH + Oh My Zsh" ON \
    "4" "Ferramentas Dev" ON \
    "5" "Utilitários Gerais" ON \
    3>&1 1>&2 2>&3)

  for CHOICE in $CHOICES; do
    case $CHOICE in
      "\"1\"") install_desktop_env;;
      "\"2\"") install_yay;;
      "\"3\"") install_zsh;;
      "\"4\"") install_dev_tools;;
      "\"5\"") install_utils;;
    esac
  done

  echo "✅ Instalação concluída. Você pode reiniciar o sistema."
}

main_menu