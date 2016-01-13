# vagrant-chef-for-laravel5.1


## サーバー構成

* OS CentOS 6.5 64bit   
	* （BOX）: [nrel/CentOS-6.5-x86_64](https://vagrantcloud.com/nrel/boxes/CentOS-6.5-x86_64)
* Apache 2.2.15
* MySQL 5.6.28
* PHP 5.6.17
	* php
	* php-devel
	* php-mbstring 
	* php-mysql 
	* php-xml 
	* php-mcrypt 
	* libmcrypt
* vim-enhanced 7.4.629
* Git 1.7.1

## サーバー概要

* ホスト名： centos
* IP アドレス: 192.168.33.10
* httpd: #80（#8080 からフォワード）
* ユーザー名/パスワード： vagrant/vagrant
* Rootパスワード： vagrant

## インストール

```bash
$ git clone -b bk https://github.com/ontheroadjp/chef-centoos-setup.git
```

## Chef の実行

### 0. SSH 設定

```bash
$ vagrant ssh-config --host centos >> ~/.ssh/config
```

とすれば、

```bash
$ ssh centos
```

で ゲスト OS へ SSH 接続が可能となる。

**その他、``~/.ssh/config`` の設定例**

```
Host sakuraroot
	HostName xxx.xxx.xxx.xxx
	Port 22
	User root
```

### 1. ホスト OS 側での準備

```bash
# data bag を暗号化する秘密鍵の生成
$ openssl rand -base64 512 > .chef/data_bag_key

# 環境変数の設定
$ export EDITOR=vim

# ユーザー（nobita）のパスワード生成
# PASSWORD の部分を実際のパスワードにすること
$ php -r 'echo crypt("PASSWORD","$6$".substr(uniqid(),0,8));' >> password.txt

# ユーザー（nobita）の作成
$ knife data bag create --secret-file .chef/data_bag_key --local users nobita
```

* vim が起動するので、以下の通り編集
* ``"password"`` の部分は上記で生成したパスワードを入力する

```json
{
	"id": "nobita",
	"shell": "/bin/bash",
	"password": "$6$5696018b$EPgCN6vj.jocDrBiax0HpIfAbI.24Dwov8K6ri45OAsiG1SxmFItFzlLEwp7eiwFjUvxDI0S/I/
	"sshkey": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL+mG+DQcUGn2iwmtt13dBlyWbOk0d063uz6HrShDm3S+6g7WYR
	"wheel": true
}
```

vim を終了すると ``data_bags/users/nobita.json`` が作成される。

### 2. ゲスト OS 側での準備

```bash
# Virtual Machine の起動
$ vagrant sandbox on
$ vagrant up

# SSH 接続
$ vagrant ssh

# iptables のリセット
$ sudo iptables --flush
```

## 3. Chef（knife solo） の実行

```bash
$ knife solo prepare centos
$ knife solo cook centos
```

## 4. インストールの確認

```bash
# Apache のバージョン確認
$ httpd -v

# php のバージョン確認
$ php -v

# MySQL のバージョン確認
$ mysql --version
```

## 参考

### ゲスト OS 起動時の起動メッセージ

```bash
$ vagrant up

Bringing machine 'default' up with 'virtualbox' provider...
==> default: Checking if box 'nrel/CentOS-6.5-x86_64' is up to date...
==> default: Clearing any previously set forwarded ports...
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: hostonly
==> default: Forwarding ports...
    default: 80 => 8080 (adapter 1)
    default: 3306 => 3306 (adapter 1)
    default: 22 => 2222 (adapter 1)
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default: Warning: Connection timeout. Retrying...
==> default: Machine booted and ready!
GuestAdditions 5.0.6 running --- OK.
==> default: Checking for guest additions in VM...
==> default: Checking for host entries
==> default: adding to (/etc/hosts) : 192.168.33.10  centos  # VAGRANT: be48b7b8b740ca08f7fcb0f5d4bb247a (default) / e02002d5-f213-4d51-90b5-0edd67a94f99
Password:
==> default: Setting hostname...
==> default: Configuring and enabling network interfaces...
==> default: Mounting shared folders...
    default: /vagrant => /Users/hideaki/Desktop/test/chef-centoos-setup
    default: /var/www/html => /Users/hideaki/Desktop/test/chef-centoos-setup/html
==> default: Machine already provisioned. Run `vagrant provision` or use the `--provision`
==> default: flag to force provisioning. Provisioners marked to run always will still run.
```