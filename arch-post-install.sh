#!/bin/bash

set -e

echo "🚀 Iniciando pós-instalação do Arch Linux..."

echo "🌐 Instalando NetworkManager (gerenciador de rede)..."
sudo pacman -S --noconfirm networkmanager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

echo "🎨 Instalando fontes comuns (inclusive fontes Microsoft)..."
sudo pacman -S --noconfirm ttf-dejavu ttf-liberation ttf-droid noto-fonts noto-fonts-emoji ttf-ms-fonts

echo "📼 Instalando suporte multimídia (áudio e codecs)..."
sudo pacman -S --noconfirm alsa-utils pulseaudio pulseaudio-alsa pavucontrol gst-libav gst-plugins-{base,good,bad,ugly}

echo "🎮 Instalando drivers gráficos para Intel (11ª geração)..."
sudo pacman -S --noconfirm mesa lib32-mesa vulkan-intel xf86-video-intel

echo "🖥️ Instalando servidor gráfico (Xorg)..."
sudo pacman -S --noconfirm xorg xorg-xinit

echo "🧱 Instalando GNOME Desktop completo..."
sudo pacman -S --noconfirm gnome gnome-extra gdm

echo "🔁 Ativando GDM..."
sudo systemctl enable gdm.service

echo "🧰 Instalando utilitários essenciais..."
sudo pacman -S --noconfirm git curl wget zip unzip nano neofetch htop

echo "🧽 Limpando cache do pacman..."
sudo pacman -Sc --noconfirm

echo "✅ Pós-instalação finalizada com sucesso!"
echo "🔁 Você pode reiniciar o sistema agora com: sudo reboot"
