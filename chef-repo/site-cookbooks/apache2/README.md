# apache2 Cookbook

## Description

1. Apache2.2.15（httpd, httpd-devel） のインストール（またはアップデート）する。
2. ``/etc/httpd/conf/httpd.conf`` の入れ替える。
3. httpd サービスの再起動をする。

参考：[Apache2.2 公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/)  
参考：[Apache2.2 コアディレクティブ公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#serveradmin)


## Requirements

* 特に必要はないが、PHP がインストール済みであれば連動する

#### packages
- `php56` - ``PHP5.6`` 及び ``php-mysql`` など関連モジュールを追加する.

## httpd.conf


### 1. DirectoryIndex の追加

```
# 変更前
DirectoryIndex index.html index.htm index.cgi

# 変更後
DirectoryIndex index.html index.htm index.cgi index.php ←追加(index.php許可)
```

### 2. MIME Type の追加

```
# 新規追加
AddType application/x-httpd-php .php
```

## Attributes

``/etc/httpd/conf/httpd.conf`` の設定

#### apache2::default


|key|Type|Description|Default|Note|
|:---|:---|:---|:---|:---|
|``['httpd']['server_admin']``|Email|サーバがクライアントに送るエラーメッセージに含める電子メールの アドレス|root@localhost|[公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#serveradmin)|
|``['httpd']['server_name']``|URL:PortNo|サーバが自分自身を示すときに使うホスト名とポート|www.example.com:80|[公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#servername)|
|``['httpd']['document_root']``|Directory Path|ウェブから見えるメインのドキュメントツリーになる ディレクトリ|/var/www/html|[公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#documentroot)|
|``['httpd']['docroot_allow_override']``|All or None or Directive Name|.htaccess で許可されるディレクティブの種類|All|[公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#allowoverride)

## Usage

#### apache2::default

Just include `apache2` in your node's `run_list` and settings for ``httpd``:

```json
{
     "httpd" : {
         "server_admin" : "root@localhost",
         "server_name" : "www.example.com:80",
         "document_root" : "/var/www/html",
         "docroot_allow_override" : "All"
     },
     "run_list": [
         "recipe[apache2]",
     ],
     "automatic": {
         "ipaddress": "xxx.xxx.xxx.xxx"
     }
}
```

## Memo

### 確認いろいろ

* httpd のバージョンを確認

	```bash
	$ httpd -v
	```

* httpd が存在しているかどうか調べる

	```bash
	$ ps -ef | grep httpd
	```

* 80 番ポートが開いているかどうか調べる

	```bash
	$ netstat -ln | grep 80
	```

### httpd コマンド

**<起動>**

```bash
$ sudo /etc/rc.d/init.d/httpd start
#または
$ sudo /etc/init.d/httpd start
```

**<停止>**

```bash
$ sudo /etc/rc.d/init.d/httpd stop
#または
$ sudo /etc/init.d/httpd stop
```

**<再起動>**

```bash
$ sudo /etc/rc.d/init.d/httpd restart
#または
$ sudo /etc/init.d/httpd restart
```

**<プロセスを停止しないで再起動>**

```bash
$ sudo /etc/rc.d/init.d/httpd graceful
#または
$ sudo /etc/init.d/httpd graceful
```

* gracefulはプロセスの通信が終わるのを待って、順次新しい設定を反映したhttpdを起動させる方法。Webサーバを公開していて、サービスの停止が出来ない場合に便利

**<httpd.conf の再読み込み>**

```bash
$ sudo /etc/rc.d/init.d/httpd reload
#または
$ sudo /etc/init.d/httpd reload
```

**<httpd.conf の書式チェック>**

```bash
$ sudo /etc/rc.d/init.d/httpd configtest
#または
$ sudo /etc/init.d/httpd configtest
```

**<状態確認>**

```bash
$ sudo /etc/rc.d/init.d/httpd status
#または
$ sudo /etc/init.d/httpd status
```

