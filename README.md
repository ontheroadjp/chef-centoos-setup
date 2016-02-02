# chef-centos-setup

CentOS6.x のサーバー環境を構築するための Chef レシピ

||サーバー|OS|テストツール|
|:---|:---|:--|:--|
|本番|さくらVPS|CentOS6.7 64bit（標準OS）|serverspec|
|開発|VirtualBox & Vagrant<br>（MacOSX El Capitan 10.11）|CentOS6.7 64bit|serverspec|

### 開発ツール

* Chef Development Kit Version: 0.9.0
	* chef-client version: 12.5.1
	* berks version: 4.0.1
	* kitchen version: 1.4.2
* VirtualBox 5.0.6
* vagrant 1.7.4
* ruby 2.3.0p0
* serverspec v2

## 1. レシピ

|No|クックブック名|本番<br>(レシピ名)|テスト<br>（レシピ名）|内容|
|:---|:---|:---:|:---:|:---|
|1|sakuravps_tunig|||不要なデーモン、パッケージの削除|
|2|users|default|default|Root 権限のある一般ユーザーの作成|
|3|yum|default|default|各種レポジトリなどの追加 & 設定|
|4|tools|default|default|vim(+lua), git などのインストール|
|5|build_tools|default|default|gcc, ccache などのインストール(v1.2.0〜)|
|6|openssl|default|default|OpenSSL 1.0.2f のソースビルド（v1.2.0〜）|
|7|curl|default|default|cURL 7.47.0 のソースビルド（v1.2.0〜）|
|8|apache2|2.4.18|2.4.18|Apache 2.2.18 のソースビルド|
|9|mysql56|default|default|Mysql 5.6.28 のパッケージインストール|
|10|php56|5.6.17|5.6.17|PHP 5.6.17 のソースビルド|
|11|service|default|default|apache, mysql のサービス登録など|
|12|webapp-dev-env|default|default|Nodejs, npm, Bower, Gulp, Composer, SASS のインストール|
|13|ruby|default|default|rbenv による Ruby 2.3.0 のインストール（v1.2.0〜）|
|14|ssh|default||sshd の設定（root 接続禁止など）|
|15|iptables|default|flush|iptables の設定|

* 空欄はレシピの適用なし
* 本番環境の詳細は ``node/sakuraroot.json`` の ``run_list`` 参照
* テスト環境の詳細は ``node/centos.json`` の ``run_list`` 参照

---

（**注意**） ``SSH`` レシピを適用すると root による SSH 接続ができなくなる

---

## 2. 開発環境（Vagrant）での実行

```bash
$ cd chef-centos-setup/chef-repo

# SSH 接続設定
$ vagrant ssh-config --host centos >> ~/.ssh/config

# インスタンス起動
$ vagrant up

# vagrant へ chef-client のインストール
$ knife solo prepare centos

# vagrant で chef 実行
$ knife solo cook centos

# テスト
$ cd chef-centos-setup/chef-repo
$ rake spec
```


## 3. 本番環境（さくら VPS）での実行

```bash
# SSH 接続の設定
# iptables レシピ適用によって Root ユーザーの接続禁止、SSH 接続ポートの変更が
# 行われるため、レシピ適用前と適用後それぞれに接続設定をする
$ vim ~/.ssh/config

# SSH レシピ適用前の接続用
Host sakuraroot
	HostName xxx.xxx.xxx.xxx
	Port 22
	User root

# SSH レシピ適用後の接続用
Host sakura
	HostName xxx.xxx.xxx.xxx
	Port 10022
	User nobita
 
# さくらVPS へ chef-client のインストール
$ knife solo prepare sakuraroot

# さくらVPS で chef 実行
$ knife solo cook sakuraroot

# 接続確認
$ ssh sakura
```


## 4. 一般ユーザーの登録について

``users`` レシピは暗号化されたユーザー情報に基づいて、一般ユーザーの登録および鍵認証による SSH 接続の自動設定を行うレシピ。このレシピを用いてサーバーにユーザーを登録しないのであれば、特に何もする必要はない。（node/xxx.json の run_list から除く必要もなし）

---

（**注意**） ``ssh`` レシピを適用すると root での SSH 接続が禁止されるため ``users`` レシピなどで root 権限を持つ一般ユーザーを作成しない場合は ``ssh`` レシピを適用てはいけない。

---

### ``users`` で作成されるユーザーのスペック

|項目|内容|
|:---|:---|
|ユーザー名|Data bag 生成時に指定（任意の名前）|
|パスワード|Data bag 生成時に指定（任意のパスワード）|
|所属グループ|Data bag 生成時に wheel に所属させるかどうかを指定する|
|sudo|wheel に所属させれば許可される|
|su|wheel に所属させれば許可される|
|ホームディレクトリ|/home/[ユーザー名]|
|ログインシェル|Data bag 生成時に指定|
|SSH 接続|``~/.ssh`` ディレクトリを作成して RSA 鍵を保存|

### Data bag の作成（準備）

``users`` レシピにて、ユーザーの自動登録を行う場合は、暗号化された Data bag を利用するため、以下が必要。

1. Data bag 暗号化のための秘密鍵の生成
2. ログイン用のユーザーパスワードの生成
3. SSH 接続用の RSA 鍵ペアの生成

（``ssh`` レシピは パスワードによる SSH 接続を禁止する（鍵認証のみ接続許可））

```bash
# data bag を暗号化する秘密鍵の生成
$ openssl rand -base64 512 > .chef/data_bag_key

# 環境変数の設定
$ export EDITOR=vim

# ユーザー（例：nobita）のパスワード生成
# PASSWORD の部分を実際のパスワードにすること（password.txt に出力される）
$ php -r 'echo crypt("PASSWORD","$6$".substr(uniqid(),0,8));' >> password.txt

# SSH 接続用の RSA 鍵ペアを生成する（パスフレーズはなし（空欄）でOK）
$ ssh-keygen -t rsa
Generating public/private rsa key pair.
Enter file in which to save the key (/Users/username/.ssh/id_rsa):  ← 作成される場所。問題なければEnter。
Enter passphrase (empty for no passphrase):  ← パスフレーズの入力。省略する場合はそのまま Enter。
Enter same passphrase again:  ← パスフレーズの再入力。省略した場合はそのまま Enter。
```

### Data bag の作成

```bash
# ユーザー（例：nobita）の作成
$ knife data bag create --secret-file .chef/data_bag_key --local users nobita

# 自動的に vim が起動するので内容を追加（計：5項目）した後に vim を終了すると
# data_bags/users/nobita.json が作成される。

# 以下、編集内容例

{
	"id": "nobita",
	"shell": "/bin/bash",
	"password": "$6$5696018b$EPgCN6vj.jocDrBiax0HpIfAbI.24Dwov8K6ri45OAsiG1SxmFItFzlLEwp7eiwFjUvxDI0S/I/",
	"sshkey": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL+mG+DQcUGn2iwmtt13dBlyWbOk0d063uz6HrShDm3S+6g7WYR",
	"wheel": true
}

# id は、変更しない
# shell は、ログインシェルを指定（通常は /bin/bash）
# password は上記で生成した暗号化されたパスワード文字列（password.txt の中身）
# sshkey は上記で生成した鍵文字列（~/.ssh/id_rsa.pub の中身）
# wheel グループに所属させる場合は true を、所属させない場合は false を指定する
# wheel グループに所属させると、sudo（パスワードなし）と su の実行権限が付与される
```

## 参考

### Vagrant による仮想環境の設定内容

|項目|内容|備考|
|:---|:---|:---|
|割り当てCPUコア|デュアルコア|vb.customize ["modifyvm", :id, "--cpus", 2]|
|割り当てメモリ|4MB|vb.customize ["modifyvm", :id, "--memory", "4096"]|
|OS|CentOS 6.7 64bit| [nrel/CentOS-6.7-x86_64](https://vagrantcloud.com/nrel/boxes/CentOS-6.7-x86_64)|
|ホスト名|centos||
|IP アドレス|192.168.33.10||
|ポートフォワード|#80 → #8080||
|NAT|DNS要求をホストマシンのDNSサーバーに要求し、ホストのリゾルバ機構を使う|vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]<br>vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]|
|ユーザー名|vagrant||
|パスワード|vagrant||
|Root パスワード|vagrant||
