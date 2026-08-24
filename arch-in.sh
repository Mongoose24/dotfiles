#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/zsh-dotfiles"
GITHUB_REPO="https://github.com/Mongoose24/zsh-dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

as_root() {
    if [ "${EUID}" -eq 0 ]; then
        "$@"
    else
        sudo "$@"
    fi
}

if [ "${EUID}" -ne 0 ] && ! command -v sudo &>/dev/null; then
    echo "ERROR: sudo is required when this script is not run as root." >&2
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    echo "ERROR: This installer requires Arch Linux's pacman package manager." >&2
    exit 1
fi

if [ "$(uname -m)" != "x86_64" ]; then
    echo "ERROR: This installer currently supports x86_64 Arch Linux systems only." >&2
    exit 1
fi

echo "==> UPDATING PACKAGES..."
as_root pacman -Syu --noconfirm

echo "==> INSTALLING CORE PACKAGES..."
as_root pacman -S --needed --noconfirm \
    sudo zsh git curl stow fzf ripgrep poppler ffmpeg file unzip wget tree htop jq eza \
    chafa rsync tmux neovim zoxide bat fd dust atuin yazi

echo "==> INSTALLING LEAF..."
if ! command -v leaf &>/dev/null; then
    curl -fsSL https://leaf.rivolink.mg/install.sh | sh
else
    echo "    leaf already installed, skipping."
fi

echo "==> INSTALLING YAZI PLUGINS..."
ya pkg install 2>/dev/null || true

echo "==> INSTALLING OH MY ZSH..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "    Oh My Zsh already installed, skipping."
fi

echo "==> INSTALLING OMZ PLUGINS..."
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions \
        "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "    zsh-autosuggestions already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zdharma-continuum/fast-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
else
    echo "    fast-syntax-highlighting already installed, skipping."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-history-substring-search" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-history-substring-search \
        "$ZSH_CUSTOM/plugins/zsh-history-substring-search"
else
    echo "    zsh-history-substring-search already installed, skipping."
fi

echo "==> INSTALLING STARSHIP..."
if ! command -v starship &>/dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
else
    echo "    Starship already installed, skipping."
fi

echo "==> INSTALLING TPM (tmux plugin manager)..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
    echo "    TPM already installed, skipping."
fi

echo "==> CLONING DOTFILES..."
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$GITHUB_REPO" "$DOTFILES_DIR"
else
    echo "    Dotfiles already cloned, pulling latest..."
    git -C "$DOTFILES_DIR" pull
fi

echo "==> STOWING DOTFILES..."
cd "$DOTFILES_DIR"

# Remove existing managed configuration so Stow can create its symlinks.
# These are intentionally discarded: this installer treats the repository as
# the source of truth for Neovim and Starship configuration.
rm -rf "$HOME/.config/nvim"
rm -f "$HOME/.config/starship.toml"

# Backup and remove any existing files that would block stow.
[ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$HOME/.zshrc.bak" && echo "    Backed up existing .zshrc"
[ -f "$HOME/.tmux.conf" ] && mv "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak" && echo "    Backed up existing .tmux.conf"

stow zsh
stow config
stow tmux

echo "==> CREATING LOCAL ZSH DIRECTORIES..."
mkdir -p "$HOME/.oh-my-zsh/custom/local-functions"
LOCAL_ZSH="$HOME/.oh-my-zsh/custom/local-functions/local-zsh.zsh"
if [ ! -f "$LOCAL_ZSH" ]; then
    touch "$LOCAL_ZSH"
    echo "    Created local-zsh.zsh"
else
    echo "    local-zsh.zsh already exists, skipping."
fi

echo "==> SETTING DEFAULT SHELL TO ZSH..."
chsh -s "$(command -v zsh)"

echo ""
echo "✓ ALL DONE! Run: exec zsh"
