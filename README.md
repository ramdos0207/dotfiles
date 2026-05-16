# dotfiles

- zshとgit周りの設定を管理する
- エディタの設定はVSCodeの同期を使う

## やること

1. git、zsh、curl、gnupgをインストールする

```sh
sudo apt install -y zsh git curl gnupg
```

2. ssh鍵を作成し、githubに登録する（必要な場合）
   ※このリポジトリはパブリックリポジトリなので、スキップすることも可能

```sh
ssh-keygen -t ed25519 -C ramdos0207
cat ~/.ssh/id_ed25519.pub
```

3. このリポジトリをクローンする

```sh
git clone https://github.com/ramdos0207/dotfiles.git
# ssh経由の場合
# git clone git@github.com:ramdos0207/dotfiles.git
```

4. インストールスクリプトを実行し、zshを再起動する
```sh
./install.sh
exec zsh
```

`install.sh` は `mise install` を実行し、以下のCLIツールもまとめて入れる。

- `eza`: 見やすい `ls`
- `bat`: シンタックスハイライト付きの `cat`
- `fd`: 高速なファイル検索
- `ripgrep`: 高速な全文検索
- `fzf`: fuzzy finder
- `zoxide`: 賢い `cd`
- `delta`: 見やすい `git diff`
- `lazygit`: Git TUI

5. GitHub CLIの認証を進める

`./install.sh` の途中で `gh auth login` が起動したら、ブラウザでGitHub認証を完了する。
GPG公開鍵は認証後に自動でGitHubへ登録される。

## そのほかやっておくこと

1. Moralerspace（などのNerd Fonts対応フォント）をインストールする
  - https://github.com/yuru7/moralerspace/releases

## tips

- `ll` / `la` / `lsa`: `eza` でファイル一覧を見やすく表示する
- `tree`: 2階層までのディレクトリツリーを表示する
- `cat`: `bat` 経由でハイライト付き表示にする
- `catt`: 行番号付きで表示する
- `Ctrl-R`: `fzf` で履歴を検索する
- `Alt-C`: `fzf` でディレクトリを選んで移動する
- `cd`: `zoxide` により、よく使うディレクトリへ賢く移動する
- `mkdircd <directory>`: ディレクトリを作成してそのまま移動する
- `wopen`: WSL上の現在ディレクトリをWindows Explorerで開く
- `clip`: WSLからWindowsクリップボードへコピーする
