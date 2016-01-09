# vagrant-chef-for-laravel5.1


## Vagrant

OS（BOX）: [nrel/CentOS-6.5-x86_64](https://vagrantcloud.com/nrel/boxes/CentOS-6.5-x86_64)

* HTTPD
* MySQL
* PHP

* php-devel
* php-mbstring 
* php-mysql 
* php-xml 
* php-mcrypt 

* libmcrypt

* vim-enhanced
* Git

## サーバー概要

ホスト名： centos
IP: 192.168.33.10
httpd: #80（#8080 からフォワード）


## インストール

### ローカルサーバーでの準備

```bash
# Git クローン
$ git clone https://github.com/ontheroadjp/chef-centoos-setup.git
$ git clone -b bk https://github.com/ontheroadjp/chef-centoos-setup.git
$ cd chef-repo

# 秘密鍵の生成
$ openssl rand -base64 512 > .chef/data_bag_key

# 環境変数の設定
$ export EDITOR=vim

# ユーザー（nobita）の作成
$ knife data bag create --secret-file .chef/data_bag_key --local users nobita
```

vim が起動するので、以下の通り編集

```vim
{
	"id": "nobita", 
	"password": "nobita" 
}
```

vim を終了すると ``data_bags/users/nobita.json`` が作成される。

## リモートサーバーへインストール

```bash
$ vagrant sandbox on
$ knife solo prepare centos
```

## リモートで Chef（knife） 実行

```bash
$ knife solo cook centos
```

MySQL インストールで以下のエラーが出る場合は、

```
Recipe: mysql56::default
  * yum_package[mysql-community-server] action install
    
    ================================================================================
    Error executing action `install` on resource 'yum_package[mysql-community-server]'
    ================================================================================
    
    Chef::Exceptions::Exec
    ----------------------
    yum -d0 -e0 -y --enablerepo=mysql56-community install mysql-community-server-5.6.27-2.el6 returned 1:
    STDOUT:  You could try using --skip-broken to work around the problem
     You could try running: rpm -Va --nofiles --nodigest
```

postfix.x86_64 ライブラリを削除する

リモートサーバーへ SSH 接続

```bash
$ vagrant ssh
```

削除コマンド実行

```bash
$ sudo yum remove -y postfix.x86_64
~
Removed:
  postfix.x86_64 2:2.6.6-2.2.el6_1

Dependency Removed:
  cronie.x86_64 0:1.4.4-12.el6        cronie-anacron.x86_64 0:1.4.4-12.el6        crontabs.noarch 0:1.10-33.el6

Complete!
```
もう一度、Chef（knife）を実行

```bash
$ knife solo cook centos
```
## インストールの確認

```bash
$ php -v
PHP 5.6.17 (cli) (built: Jan  6 2016 19:05:40) 
Copyright (c) 1997-2015 The PHP Group
Zend Engine v2.6.0, Copyright (c) 1998-2015 Zend Technologies
    with Zend OPcache v7.0.6-dev, Copyright (c) 1999-2015, by Zend Technologies
    with Xdebug v2.3.3, Copyright (c) 2002-2015, by Derick Rethans
-bash: __git_ps1: command not found

$ mysql --version
mysql  Ver 14.14 Distrib 5.6.27, for Linux (x86_64) using  EditLine wrapper
-bash: __git_ps1: command not found
```
