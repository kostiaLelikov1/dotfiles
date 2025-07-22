#!/bin/bash
set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting macOS setup...${NC}"

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo -e "${RED}Error: This script is designed for macOS only${NC}"
    exit 1
fi

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo -e "${GREEN}Homebrew is already installed${NC}"
fi

# Update Homebrew
echo -e "${YELLOW}Updating Homebrew...${NC}"
brew update

# Install chezmoi if not already installed
if ! command -v chezmoi &> /dev/null; then
    echo -e "${YELLOW}Installing chezmoi...${NC}"
    brew install chezmoi
else
    echo -e "${GREEN}chezmoi is already installed${NC}"
fi

# Get GitHub username
echo -n "Enter your GitHub username (for chezmoi repo): "
read GITHUB_USERNAME

# Initialize and apply chezmoi
echo -e "${YELLOW}Initializing chezmoi with your dotfiles...${NC}"
chezmoi init --apply "https://github.com/${GITHUB_USERNAME}/dotfiles.git"

echo -e "${GREEN}Setup complete!${NC}"
echo -e "${YELLOW}Note: You may need to restart your terminal for all changes to take effect.${NC}"