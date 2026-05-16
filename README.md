# dotfiles

- とりあえずzsh周りだけを管理する
- エディタの設定はVSCodeの同期を使う

## やること

1. git、zsh、curlをインストールする

```sh
sudo apt install -y zsh git curl
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

## そのほかやっておくこと

1. Moralerspace（などのNerd Fonts対応フォント）をインストールする
  - https://github.com/yuru7/moralerspace/releases


## todo
- シェルをもっとクールにする
- .gitconfig類をリポジトリに入れる