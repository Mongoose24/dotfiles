#!/usr/bin/env bash
set -e

DOTFILES_DIR="$HOME/zsh-dotfiles"
GITHUB_REPO="https://github.com/Mongoose24/zsh-dotfiles.git"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "==> REMOVING OLD DOTFILES SYMLINKS..."
rm -f "$HOME/.zshrc" "$HOME/.p10k.zsh" "$HOME/.config"
rm -f "$ZSH_CUSTOM/aliases.zsh" "$ZSH_CUSTOM/custom.zsh" "$ZSH_CUSTOM/functions"

echo "==> REMOVING OLD DOTFILES REPO..."
rm -rf "$HOME/dotfiles"

echo "==> CLONING DOTFILES..."
if [ ! -d "$DOTFILES_DIR" ]; then
    git clone "$GITHUB_REPO" "$DOTFILES_DIR"
else
    echo "    Already cloned, pulling latest..."
    git -C "$DOTFILES_DIR" pull
fi

echo "==> SYMLINKING DOTFILES..."
ln -sf "$DOTFILES_DIR/zsh/.zshrc"                              "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/p10k/.p10k.zsh"                         "$HOME/.p10k.zsh"
ln -sf "$DOTFILES_DIR/zsh/.oh-my-zsh/custom/aliases.zsh"      "$ZSH_CUSTOM/aliases.zsh"
ln -sf "$DOTFILES_DIR/zsh/.oh-my-zsh/custom/custom.zsh"       "$ZSH_CUSTOM/custom.zsh"
ln -sf "$DOTFILES_DIR/zsh/.oh-my-zsh/custom/functions"        "$ZSH_CUSTOM/functions"

# config — link per-file, .config dir already exists on TrueNAS
mkdir -p "$HOME/.config/nano" "$HOME/.config/yazi" "$HOME/.config/atuin" "$HOME/.config/micro"
ln -sf "$DOTFILES_DIR/config/.config/nano/glsl.nanorc"        "$HOME/.config/nano/glsl.nanorc"
ln -sf "$DOTFILES_DIR/config/.config/nano/toml.nanorc"        "$HOME/.config/nano/toml.nanorc"
ln -sf "$DOTFILES_DIR/config/.config/nano/nanorc"             "$HOME/.config/nano/nanorc"
ln -sf "$DOTFILES_DIR/config/.config/yazi/yazi.toml"          "$HOME/.config/yazi/yazi.toml"
ln -sf "$DOTFILES_DIR/config/.config/yazi/keymap.toml"        "$HOME/.config/yazi/keymap.toml"
ln -sf "$DOTFILES_DIR/config/.config/atuin/config.toml"       "$HOME/.config/atuin/config.toml"
ln -sf "$DOTFILES_DIR/config/.config/micro/bindings.json"     "$HOME/.config/micro/bindings.json"
ln -sf "$DOTFILES_DIR/config/.config/micro/settings.json"     "$HOME/.config/micro/settings.json"

echo "==> CREATING LOCAL ZSH DIRECTORIES..."
mkdir -p "$ZSH_CUSTOM/local-functions"
LOCAL_ZSH="$ZSH_CUSTOM/local-functions/local-zsh.zsh"
if [ ! -f "$LOCAL_ZSH" ]; then
    touch "$LOCAL_ZSH"
    echo "    Created local-zsh.zsh"
else
    echo "    local-zsh.zsh already exists, skipping."
fi

echo ""
echo "✓ ALL DONE! Run: exec zsh"
