# Enable Powerlevel10k instant prompt. Keep this close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
  git
  colorize
  cp
  github
  golang
  docker
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
)

ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
fpath+=("$ZSH_CUSTOM/plugins/zsh-completions/src")

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 "Oh My Zsh is not installed. Run ~/dev/dotfiles/install.sh."
fi

alias lsa="ls -lahF"

path_prepend() {
  [[ -d "$1" ]] && case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_append() {
  [[ -d "$1" ]] && case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$PATH:$1" ;;
  esac
}

path_prepend "$HOME/go/bin"
[[ -n "${GOROOT:-}" ]] && path_prepend "$GOROOT/bin"
path_append "$HOME/.local/bin"

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
