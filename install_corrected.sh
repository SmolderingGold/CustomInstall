bash <(cat << 'EOF'
set -e  # Exit immediately if a command fails

echo "Starting installation..."
sudo apt update && sudo apt upgrade -y

echo "Installing Atuin..."
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
# Check if atuin is already in bashrc before adding it
if ! grep -q "atuin init bash" ~/.bashrc; then
    echo 'eval "$(atuin init bash)"' >> ~/.bashrc
fi

echo "Installing Redshift..."
sudo apt install -y redshift redshift-gtk

echo "Configuring Flatpak..."
# Linux Mint usually has Flatpak and Flathub enabled by default,
# but this ensures it is set up correctly.
sudo apt install -y flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Installing Steam..."
sudo apt install -y steam-installer

echo "Installing FauGus Launcher..."
sudo dpkg --add-architecture i386
# Check if PPA is already added to avoid errors or duplicates
if ! grep -q "faugus/faugus-launcher" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    sudo add-apt-repository -y ppa:faugus/faugus-launcher
fi
sudo apt update
sudo apt install -y faugus-launcher

echo "Installing Flatpak Apps (Vesktop, CopyQ, LibreWolf)..."
# Installing all flatpaks in one command is slightly faster
flatpak install -y flathub dev.vencord.Vesktop com.github.hluk.copyq io.gitlab.librewolf-community

echo "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

echo "---------------------------------------------------"
echo "Installation complete!" 
echo "Please run: source ~/.bashrc"
echo "---------------------------------------------------"
EOF
)
