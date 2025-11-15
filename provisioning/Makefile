export SHELL              = zsh
export DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .gitignore .zshrc_local.example
export DOTFILES_DIR      := $(HOME)/dotfiles
export DOTFILES_TARGET   := $(wildcard $(DOTFILES_DIR)/.??*)
export DOTFILES_FILES    := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

ifdef m
  __COMMIT_MESSAGE=`-m ${m}`
endif

# 擬似ターゲット（タスクターゲット）の宣言
.PHONY: all \
	help \
	install \
	test \
	update \
	push \
	pull \
	clean

all: help

help: ##ヘルプ表示
	@grep -F '##' $(MAKEFILE_LIST) | grep -v grep | sed -e 's/##//g'

install: ##開発ツールのインストール
	@${SHELL} $(DOTFILES_DIR)/provisioning/init/install.sh

update: ##開発ツールの更新
	@echo 'Homebrewのアップデート =>'
	@brew update
	@echo '更新のあるformula =>'
	@brew outdated
	@echo 'パッケージのアップデート =>'
	@brew upgrade --greedy
	@echo '古いバージョンのformula一覧 =>'
	@brew cleanup -n
	@echo '古いバージョンのformulaを削除 =>'
	@brew cleanup
	@echo 'doctor =>'
	@brew doctor

test: ##コマンドの実行可否をチェック
	@${SHELL} $(DOTFILES_DIR)/provisioning/test.sh

ssh-ubuntu: ##ubuntuのコンテナにssh
	@docker pull ubuntu:20.04
	@docker run --rm --name ubuntu-test -it ubuntu /bin/bash
	@docker rmi ubuntu:20.04

push: ##ファイルの変更をリモートに反映
	@cd $(DOTFILES_DIR) && git add .
	@cd $(DOTFILES_DIR) && git commit $(__COMMIT_MESSAGE)
	@cd $(DOTFILES_DIR) && git push -u origin $$(git branch --show-current)

pull: ##リモートのファイルを取得
	@cd $(DOTFILES_DIR) && git pull origin $$(git branch --show-current)

clean: ##setup.shで構築したシェルの設定を破棄
	@$(foreach val, $(DOTFILES_FILES), unlink $(HOME)/$(val);)
	@cd ../ && rm -rf $(DOTFILES_DIR)
