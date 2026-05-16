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
  export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"

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
  export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
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

print_gpg_public_key() {
  local signing_key="$1"

  if ! gpg --list-secret-keys "$signing_key" >/dev/null 2>&1; then
    info "GPG key $signing_key is configured, but no local secret key was found"
    return
  fi

  info "Register this GPG public key on GitHub"
  gpg --armor --export "$signing_key"
}

register_gpg_key_with_github() {
  local signing_key="$1"
  local public_key_file
  local title

  if ! gpg --list-secret-keys "$signing_key" >/dev/null 2>&1; then
    info "GPG key $signing_key is configured, but no local secret key was found"
    return
  fi

  if ! need_cmd gh; then
    info "GitHub CLI is not available"
    print_gpg_public_key "$signing_key"
    return
  fi

  if ! gh auth status >/dev/null 2>&1; then
    info "Logging in to GitHub with gh"
    gh auth login
  fi

  public_key_file="$(mktemp)"
  gpg --armor --export "$signing_key" >"$public_key_file"
  title="$(hostname)-$(date +%Y%m%d)"

  if gh gpg-key add "$public_key_file" --title "$title"; then
    info "Registered GPG public key on GitHub"
  else
    info "Could not register GPG public key with gh. It may already be registered."
    print_gpg_public_key "$signing_key"
  fi

  rm -f "$public_key_file"
}

setup_git_gpg_key() {
  local local_config="$HOME/.gitconfig.local"
  local name="ramdos0207"
  local email="dev@ramdos.net"
  local identity="${name} <${email}>"
  local signing_key

  signing_key="$(git config --file "$local_config" --get user.signingKey 2>/dev/null || true)"
  if [[ -n "$signing_key" ]]; then
    info "Git signing key is already configured"
    register_gpg_key_with_github "$signing_key"
    return
  fi

  signing_key="$(gpg --batch --list-secret-keys --with-colons "$email" 2>/dev/null | awk -F: '$1 == "fpr" { print $10; exit }' || true)"
  if [[ -z "$signing_key" ]]; then
    info "Generating GPG key for ${identity}"
    gpg --batch --pinentry-mode loopback --passphrase '' --quick-generate-key "$identity" ed25519 sign 0
    signing_key="$(gpg --batch --list-secret-keys --with-colons "$email" | awk -F: '$1 == "fpr" { print $10; exit }')"
  fi

  git config --file "$local_config" user.signingKey "$signing_key"

  info "Configured Git signing key: $signing_key"
  register_gpg_key_with_github "$signing_key"
}

if ! need_cmd git; then
  printf 'git is required to install zsh dependencies.\n' >&2
  exit 1
fi

if ! need_cmd zsh; then
  printf 'zsh is required. Install zsh with your system package manager first.\n' >&2
  exit 1
fi

if ! need_cmd gpg; then
  printf 'gpg is required. Install gnupg with your system package manager first.\n' >&2
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
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

info "Installing mise tools"
mise install

setup_git_gpg_key

info "Done. Restart your shell with: exec zsh"
