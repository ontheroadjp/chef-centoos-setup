# Docker-Chef

## 概要

* Docker コンテナを用いた Chef レシピのテスト実行スクリプト
* 以下を自動実行する

	1. Docker コンテナの起動
	2. Docker コンテナに対して Chef レシピの適用
	3. Docker コンテナの停止
	4. Docker コンテナの破棄

## 使い方

* chef-repo ディレクトリで以下のコマンド実行する

```bash
$ sh docker/docker-chef.sh
```

