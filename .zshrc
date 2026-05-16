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

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
