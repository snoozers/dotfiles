# dotfiles

<img width="2000" alt="logo" src="https://user-images.githubusercontent.com/49787185/128835360-5d75746a-a123-49bb-bcb2-5c77a61821e0.png">

## 📋 概要

このdotfilesは **[Oh My Zsh](https://ohmyz.sh/)** + **[Powerlevel10k](https://github.com/romkatv/powerlevel10k)** をベースとしたzsh環境設定です。

### 依存関係

- **Oh My Zsh** - `~/.oh-my-zsh` にインストールされます
- **Powerlevel10k** - Oh My Zshのカスタムテーマとしてインストールされます
- **プラグイン**:
  - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions) - コマンド履歴からの自動補完
  - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting) - コマンドのシンタックスハイライト

## 🗂️ ディレクトリ構成

```
~/
├── .oh-my-zsh/                  # Oh My Zsh本体（ホームディレクトリにインストール）
│   ├── oh-my-zsh.sh
│   ├── plugins/                 # 公式プラグイン
│   ├── themes/                  # 公式テーマ
│   └── custom/
│       ├── plugins/
│       │   ├── zsh-autosuggestions/      # カスタムプラグイン
│       │   └── zsh-syntax-highlighting/  # カスタムプラグイン
│       └── themes/
│           └── powerlevel10k/            # Powerlevel10kテーマ
│
├── .vim/                        # Vim設定ディレクトリ（ホームディレクトリにインストール）
│   └── bundle/
│       └── Vundle.vim/          # Vundleプラグインマネージャ
│
├── dotfiles/                    # このリポジトリ
│   ├── .zshenv                  # Zsh環境変数（最初に読み込まれる）
│   ├── .zprofile                # ログインシェル用の環境変数設定
│   ├── .zshrc                   # Zsh設定ファイル（シンボリックリンク元）
│   ├── .p10k.zsh                # Powerlevel10k設定
│   ├── .vimrc                   # Vim設定
│   ├── .zshrc_local.example     # マシン固有設定のテンプレート
│   └── bin/
│       ├── setup.sh             # 統合セットアップスクリプト（メイン）
│       ├── setup_zsh.sh         # Zsh環境セットアップ
│       └── setup_vim.sh         # Vim環境セットアップ
│
├── .zshenv -> ~/dotfiles/.zshenv        # シンボリックリンク
├── .zprofile -> ~/dotfiles/.zprofile    # シンボリックリンク
├── .zshrc -> ~/dotfiles/.zshrc          # シンボリックリンク
├── .p10k.zsh -> ~/dotfiles/.p10k.zsh    # シンボリックリンク
└── .vimrc -> ~/dotfiles/.vimrc          # シンボリックリンク
```

## 🚀 セットアップ

### 1. リポジトリをクローン

```bash
git clone https://github.com/snoozers/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 2. セットアップスクリプトを実行

```bash
zsh bin/setup.sh
```

セットアップスクリプトは以下を**自動的に実行**します：

#### Zsh環境
1. Oh My Zshのインストール（`~/.oh-my-zsh`）
2. Powerlevel10kテーマのインストール
3. 推奨プラグインのインストール
   - zsh-autosuggestions（コマンド自動補完）
   - zsh-syntax-highlighting（シンタックスハイライト）

#### Vim環境
1. Vundle（プラグインマネージャ）のインストール
2. Vimプラグインのインストール

#### 設定ファイル
- `~/.zshenv` → `~/dotfiles/.zshenv`
- `~/.zprofile` → `~/dotfiles/.zprofile`
- `~/.zshrc` → `~/dotfiles/.zshrc`
- `~/.p10k.zsh` → `~/dotfiles/.p10k.zsh`
- `~/.vimrc` → `~/dotfiles/.vimrc`

### 3. フォントのインストール（必須）

**Powerlevel10kを正しく表示するには専用フォントが必須です！**

#### macOSの場合

```bash
# Homebrewでインストール（推奨）
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font

# または他のNerd Fontをインストール
brew install font-hack-nerd-font
brew install font-fira-code-nerd-font
```

#### Linuxの場合

```bash
# Debian/Ubuntu
sudo apt install fonts-powerline

# Arch Linux
sudo pacman -S ttf-meslo-nerd

# または手動インストール
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
fc-cache -f -v
```

#### 手動インストール

1. [Meslo Nerd Font](https://github.com/romkatv/powerlevel10k#manual-font-installation) をダウンロード
2. フォントファイル（`.ttf`）をダブルクリックしてインストール

#### ターミナルでフォントを設定

使用しているターミナルエミュレータの設定でフォントを `MesloLGS NF` に変更してください。

**VS Code統合ターミナルの場合：**
```json
// settings.json
{
  "terminal.integrated.fontFamily": "MesloLGS NF"
}
```

### 4. シェルを再起動

```bash
exec zsh
```

初回起動時にPowerlevel10kの設定ウィザードが表示される場合があります。
指示に従って好みの見た目を選択してください。

### 5. （オプション）マシン固有の設定

マシン固有の設定（エイリアス、環境変数など）は `.zshrc_local` に記述します：

```bash
# .zshrc_local.example をコピー
cp ~/dotfiles/.zshrc_local.example ~/.zshrc_local

# 必要な設定を追加
vim ~/.zshrc_local
```

設定例は `.zshrc_local.example` を参照してください。

## 🔄 更新方法

### Oh My Zsh本体の更新

```bash
omz update
```

### プラグインとテーマの更新

```bash
# 全て一括更新
cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull && \
cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull && \
cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull

# または個別に更新
cd ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && git pull
cd ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && git pull
cd ~/.oh-my-zsh/custom/themes/powerlevel10k && git pull
```

### dotfiles設定の更新

```bash
cd ~/dotfiles
git pull
```

## 🎨 テーマの変更

### Powerlevel10kの再設定

```bash
p10k configure
```

対話的なウィザードでプロンプトの見た目を変更できます。設定は `~/.p10k.zsh` に保存されます。

### 他のテーマに変更する場合

1. `.zshrc` の `ZSH_THEME` を編集：

```bash
# ~/dotfiles/.zshrc
ZSH_THEME="robbyrussell"  # または他のテーマ名
```

2. 利用可能なテーマ一覧を確認：

```bash
ls ~/.oh-my-zsh/themes/
```

3. テーマプレビュー：

```bash
# 一時的にテーマを試す
source ~/.oh-my-zsh/themes/テーマ名.zsh-theme
```

### カスタムテーマのインストール

```bash
# 例：dracula テーマをインストール
git clone https://github.com/dracula/zsh.git ~/.oh-my-zsh/custom/themes/dracula
ln -s ~/.oh-my-zsh/custom/themes/dracula/dracula.zsh-theme ~/.oh-my-zsh/custom/themes/dracula.zsh-theme

# .zshrc で指定
ZSH_THEME="dracula"
```

## 🔌 プラグインの追加

新しいプラグインを追加する場合：

### 1. プラグインをインストール

```bash
# 例：zsh-completions をインストール
git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions
```

### 2. .zshrc に追加

```bash
# ~/dotfiles/.zshrc
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions  # 追加
)
```

### 3. シェルを再起動

```bash
exec zsh
```

## 🛠️ トラブルシューティング

### Oh My Zshが見つからない

```bash
# Oh My Zshを再インストール
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# または setup_zsh.sh を再実行
zsh ~/dotfiles/bin/setup_zsh.sh
```

### プラグインが動作しない

```bash
# プラグインディレクトリを確認
ls ~/.oh-my-zsh/custom/plugins/

# プラグインを再インストール
rm -rf ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

exec zsh
```

### Powerlevel10kが表示されない

```bash
# フォントのインストールを確認
p10k configure

# テーマを再インストール
rm -rf ~/.oh-my-zsh/custom/themes/powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

exec zsh
```

## 📝 カスタマイズ例

### エイリアスの追加

`~/.zshrc_local` に追加：

```bash
alias ll='ls -alF'
alias g='git'
alias d='docker'
```

### 環境変数の設定

`~/.zshrc_local` に追加：

```bash
export EDITOR=vim
export PATH="$HOME/bin:$PATH"
```

## 📚 参考リンク

- [Oh My Zsh 公式サイト](https://ohmyz.sh/)
- [Powerlevel10k GitHub](https://github.com/romkatv/powerlevel10k)
- [Oh My Zsh プラグイン一覧](https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins)
- [Oh My Zsh テーマ一覧](https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
