#!/bin/zsh

# Function to check if a command is available
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to install packages using the appropriate package manager
install_packages() {
  if command_exists xbps-install; then
    sudo xbps-install -S neovim nerd-fonts nodejs gcc libstdc++ git lua
  elif command_exists apt; then
    sudo apt update
    sudo apt install -y neovim nerd-fonts-complete nodejs npm build-essential git lua
  elif command_exists dnf; then
    sudo dnf install -y neovim Nerd Fonts-Complete nodejs npm git lua
  elif command_exists pacman; then
    sudo pacman -Sy --noconfirm neovim nerd-fonts-complete nodejs npm git lua
  else
    echo "Unsupported package manager. Please install the required packages manually."
    exit 1
  fi
}

# Check if Neovim is installed and the version is >= 0.8.1
if command_exists nvim; then
  nvim_version=$(nvim --version | awk '/NVIM/{print $2}')
  required_version="0.8.1"

  if [ "$(printf '%s\n' "$required_version" "$nvim_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "Neovim version is below 0.8.1. Please upgrade Neovim manually."
    exit 1
  fi
else
  echo "Neovim is not installed. Please install Neovim manually."
  exit 1
fi

# Check if NodeJS and npm are installed
if ! command_exists node || ! command_exists npm; then
  echo "NodeJS with npm is not installed. Installing..."
  install_packages
fi

# Check for C compiler and libstdc++ (assuming gcc is the compiler)
if ! command_exists gcc || ! command_exists libstdc++; then
  echo "C compiler or libstdc++ is not installed. Installing..."
  install_packages
fi

# Check if Git is installed
if ! command_exists git; then
  echo "Git is not installed. Installing..."
  install_packages
fi

# Install Neovim plugin manager Packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "All dependencies are installed successfully."
