#!/bin/bash

echo "🌐 Atualizando o sistema..."
sudo pacman -Syu --noconfirm

echo "⬇️ Instalando servidor gráfico (Xorg)..."
sudo pacman -S --noconfirm xorg

echo "⬇️ Instalando drivers de vídeo para Intel (11ª geração)..."
sudo pacman -S --noconfirm mesa lib32-mesa vulkan-intel xf86-video-intel

# Função para instalar o GNOME
install_gnome() {
  echo "🖥️ Instalando GNOME Desktop completo..."
  sudo pacman -S --noconfirm gnome gnome-extra gdm

  echo "🔁 Ativando GDM (gerenciador de login do GNOME)..."
  sudo systemctl enable gdm.service
}

# Função para instalar o KDE Plasma
install_kde() {
  echo "🖥️ Instalando KDE Plasma Desktop completo..."
  sudo pacman -S --noconfirm plasma kde-applications sddm

  echo "🔁 Ativando SDDM (gerenciador de login do KDE)..."
  sudo systemctl enable sddm.service
}

# Menu de escolha
echo ""
echo "Qual ambiente de desktop você deseja instalar?"
echo "1) GNOME"
echo "2) KDE Plasma"
read -p "Digite 1 ou 2 e pressione Enter: " choice

case $choice in
  1)
    install_gnome
    ;;
  2)
    install_kde
    ;;
  *)
    echo "❌ Opção inválida. Encerrando o script."
    exit 1
    ;;
esac

echo "✅ Instalação concluída com sucesso!"
echo "🔁 Reinicie o sistema com: sudo reboot"
