# dotfiles
<img width="2000" alt="logo" src="https://user-images.githubusercontent.com/49787185/128835360-5d75746a-a123-49bb-bcb2-5c77a61821e0.png">

## 構成

```
dotfiles/
├── .zshrc, .vimrc, etc.     # 設定ファイル（OS非依存）
├── .zshrc_local.example     # マシン固有設定のテンプレート
├── bin/                     # dotfiles固有のスクリプト
│   └── setup_prezto.sh      # Prezto設定スクリプト
└── provisioning/            # OS依存のプロビジョニングスクリプト（将来的に別リポジトリへ移行予定）
    ├── Makefile             # タスクランナー
    ├── iterm2/              # iTerm2設定（macOS専用）
    ├── init/                # セットアップスクリプト
    │   ├── setup.sh         # 初期セットアップ
    │   └── install.sh       # 開発ツールインストール
    ├── test.sh              # コマンド確認スクリプト
    └── bin/                 # ユーティリティスクリプト
```

## .zshrc_local の使い方

マシン固有の設定（エイリアス、環境変数など）は`.zshrc_local`に記述します：

```bash
# .zshrc_local.exampleをコピーして使用
$ cp ~/.zshrc_local.example ~/.zshrc_local

# 必要な設定を追加
$ vim ~/.zshrc_local
```

macOS固有の設定例は`.zshrc_local.example`を参照してください。

## Preztoのセットアップ

Prezto（zshの設定フレームワーク）のシンボリックリンクを設定します：

```bash
# dotfilesディレクトリに移動
$ cd ~/dotfiles

# Preztoのセットアップスクリプトを実行
$ zsh bin/setup_prezto.sh
```

このスクリプトは、Preztoの設定ファイル（`.zprezto/runcoms/`）からホームディレクトリへシンボリックリンクを作成します。

## shellの設定

```bash
# Mac
$ curl -L raw.github.com/snoozers/dotfiles/master/provisioning/init/setup.sh | bash

# Debian (現在サポート不完全)
$ apt update && apt-get install -y curl && curl -L raw.github.com/snoozers/dotfiles/master/provisioning/init/setup.sh | bash
```

## アプリケーションのインストール

```bash
$ cd ~/dotfiles/provisioning
$ make install
```

## その他のコマンド

```bash
$ cd ~/dotfiles/provisioning
$ make          # ヘルプ表示
$ make test     # インストール済みコマンドの確認
$ make update   # Homebrewパッケージの更新
```
