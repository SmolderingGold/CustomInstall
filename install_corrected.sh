#!/bin/bash

# Linux Mint "Gamer Reconstruction" Script
# INSTALLS: Atuin, Redshift, Steam, Vesktop, FauGus, CopyQ, LibreWolf
# METHOD: Mix of APT, Flatpak, and Curl as requested.

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}==============================================${NC}"
echo -e "${YELLOW}   INSTALLING GAMING & POWER USER SUITE       ${NC}"
echo -e "${YELLOW}==============================================${NC}"
sleep 2

# 1. PRE-REQUISITES
# Ensure curl and apt-transport-https are present for repo handling
echo -e "\n${GREEN}=== 1. Installing Prerequisites ===${NC}"
sudo apt update
sudo apt install -y curl wget gpg apt-transport-https

# 2. FLATPAK SETUP
# Mint usually includes it, but we force the remote add as requested.
echo -e "\n${GREEN}=== 2. Configuring Flatpak ===${NC}"
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
echo "Flatpak configured."

# 3. ATUIN (Shell History)
echo -e "\n${GREEN}=== 3. Installing Atuin (via Curl) ===${NC}"
# Installs binary
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# Adds init to bashrc safely (checks if it exists first to avoid duplicates)
if ! grep -q "atuin init bash" ~/.bashrc; then
    echo 'eval "$(atuin init bash)"' >> ~/.bashrc
    echo "Atuin added to .bashrc"
else
    echo "Atuin already in .bashrc, skipping."
fi

# 4. REDSHIFT (Eye Care)
echo -e "\n${GREEN}=== 4. Installing Redshift (via APT) ===${NC}"
sudo apt install -y redshift redshift-gtk

# 5. LIBREWOLF (The Future-Proof Way)
echo -e "\n${GREEN}=== 5. Installing LibreWolf ===${NC}"
# This line grabs the underlying Ubuntu name (e.g., noble, jammy, focal)
# directly from the system, regardless of if it's Mint 21, 22, or 23.
UBUNTU_BASE=$(grep UBUNTU_CODENAME /etc/os-release | cut -d'=' -f2)

wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $UBUNTU_BASE
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF

sudo apt update
sudo apt install -y librewolf

# 6. FAUGUS LAUNCHER (Game Manager)
echo -e "\n${GREEN}=== 6. Installing FauGus Launcher (via PPA) ===${NC}"
# Enable 32-bit architecture (Required for Steam & Faugus/Wine)
sudo dpkg --add-architecture i386
# Add PPA
sudo add-apt-repository -y ppa:faugus/faugus-launcher
sudo apt update
sudo apt install -y faugus-launcher

# 7. STEAM (Gaming)
echo -e "\n${GREEN}=== 7. Installing Steam (via APT) ===${NC}"
# This pulls in many 32-bit dependencies. 
sudo apt install -y steam-installer

# 8. FLATPAK APPS
echo -e "\n${GREEN}=== 8. Installing Flatpaks (Vesktop & CopyQ) ===${NC}"
# Vesktop (Better Discord)
flatpak install -y flathub dev.vencord.Vesktop
# CopyQ (Clipboard Manager)
flatpak install -y flathub com.github.hluk.copyq

echo -e "\n${GREEN}==============================================${NC}"
echo -e "${GREEN}   INSTALLATION COMPLETE                      ${NC}"
echo -e "${GREEN}==============================================${NC}"
echo "Recommendation: Log out and back in to apply Flatpak paths and Atuin shell."