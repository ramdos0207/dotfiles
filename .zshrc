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

HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
setopt inc_append_history
setopt share_history

zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
fpath+=("$ZSH_CUSTOM/plugins/zsh-completions/src")

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -u2 "Oh My Zsh is not installed. Run ~/dev/dotfiles/install.sh."
fi

if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv zsh)"
fi

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

if command -v fd >/dev/null 2>&1; then
  export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
fi

if command -v bat >/dev/null 2>&1; then
  export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range :200 {}"'
fi

export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info"

if command -v fzf >/dev/null 2>&1; then
  eval "$(fzf --zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh --cmd cd)"
fi

if command -v eza >/dev/null 2>&1; then
  alias ls="eza --group-directories-first --icons=auto"
  alias ll="eza -lah --git --group-directories-first --icons=auto"
  alias la="eza -la --group-directories-first --icons=auto"
  alias lsa="eza -lah --group-directories-first --icons=auto"
  alias tree="eza --tree --level=2 --group-directories-first --icons=auto"
else
  alias ll="ls -lhF"
  alias la="ls -laF"
  alias lsa="ls -lahF"
fi

if command -v bat >/dev/null 2>&1; then
  alias cat="bat --paging=never --style=plain"
  alias catt="bat --paging=never --style=numbers"
fi

if command -v explorer.exe >/dev/null 2>&1; then
  alias wopen="explorer.exe ."
fi

if command -v clip.exe >/dev/null 2>&1; then
  alias clip="clip.exe"
fi

mkdircd() {
  if [[ $# -ne 1 ]]; then
    print -u2 "usage: mkdircd <directory>"
    return 2
  fi

  mkdir -p -- "$1" && cd -- "$1"
}

[[ -r "$HOME/.p10k.zsh" ]] && source "$HOME/.p10k.zsh"
