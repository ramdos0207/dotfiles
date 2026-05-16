#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

info() {
  printf '==> %s\n' "$*"
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1
}

install_mise() {
  export PATH="$HOME/.local/bin:$PATH"

  if need_cmd mise; then
    info "mise is already installed"
    return
  fi

  if ! need_cmd curl; then
    printf 'curl is required to install mise.\n' >&2
    exit 1
  fi

  info "Installing mise"
  curl https://mise.run | sh
  export PATH="$HOME/.local/bin:$PATH"
}

clone_or_update() {
  local repo="$1"
  local dest="$2"

  if [[ -d "$dest/.git" ]]; then
    info "Updating ${dest#$HOME/}"
    git -C "$dest" pull --ff-only
  elif [[ -e "$dest" ]]; then
    info "Skipping ${dest#$HOME/}: path exists and is not a git repo"
  else
    info "Cloning ${repo}"
    git clone --depth=1 "$repo" "$dest"
  fi
}

link_file() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    info "Already linked ${target#$HOME/}"
    return
  fi

  if [[ -e "$target" || -L "$target" ]]; then
    mkdir -p "$BACKUP_DIR"
    info "Backing up ${target#$HOME/}"
    mv "$target" "$BACKUP_DIR/"
  fi

  info "Linking ${target#$HOME/}"
  mkdir -p "$(dirname "$target")"
  ln -s "$source" "$target"
}

if ! need_cmd git; then
  printf 'git is required to install zsh dependencies.\n' >&2
  exit 1
fi

if ! need_cmd zsh; then
  printf 'zsh is required. Install zsh with your system package manager first.\n' >&2
  exit 1
fi

install_mise

clone_or_update "https://github.com/ohmyzsh/ohmyzsh.git" "$HOME/.oh-my-zsh"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
mkdir -p "$ZSH_CUSTOM/plugins" "$ZSH_CUSTOM/themes"

clone_or_update "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k"
clone_or_update "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_update "https://github.com/zsh-users/zsh-completions.git" "$ZSH_CUSTOM/plugins/zsh-completions"

link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
link_file "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

info "Installing mise tools"
mise install

info "Done. Restart your shell with: exec zsh"
