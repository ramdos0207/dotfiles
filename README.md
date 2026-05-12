# dotfiles

Zsh setup for my WSL/Linux environment. The configuration mirrors the current
local shell: Oh My Zsh, Powerlevel10k, Go/Rust/Node/Bun/Homebrew paths, and a
small set of productivity plugins.

## What It Installs

- `~/.zshrc`
- `~/.zshenv`
- `~/.p10k.zsh`
- Oh My Zsh, if it is missing
- Powerlevel10k and the custom zsh plugins used by `.zshrc`

## Usage

```sh
./install.sh
```

The installer backs up existing files with a timestamp before creating symlinks
to this repository.

After installation, restart zsh:

```sh
exec zsh
```

## Notes

- A Nerd Font is recommended for the Powerlevel10k prompt.
- Optional tools such as `go`, `cargo`, `nvm`, `brew`, and `bun` are loaded only
  when their files or directories exist.