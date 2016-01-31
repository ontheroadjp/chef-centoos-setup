# Apache2 Cookbook

## Description

* Apache 2.4.18 のソースビルド
* 上記に必要なツール/ライブラリのインストール
* Service 登録（OS 起動時の httpd 自動起動）

## Details

1. apache ユーザーの作成
2. apache グループの作成
3. ソースビルドに必要な ``wget`` ``tar`` ``gcc`` ``gcc-c++`` ``make`` ``pcre`` ``pcre-devel`` のパッケージインストール(またはアップデート)
4. ARP(Apache Portable Runtime) 1.5.2 のソースビルド

	```
	./configure --prefix=/opt/apr/apr-1.5.2
	```

5. ARP-util のソースビルド

	```
	./configure \
	--prefix=/opt/apr/apr-util-1.5.4 \
	--with-apr=/opt/apr/apr-1.5.2
	```

6. Apache 2.4.18 のソースビルド

	```
	./configure \
	--prefix=/usr/local/apache2 \
	--with-apr=/opt/apr/apr-1.5.2 \
	--with-apr-util=/opt/apr/apr-util-1.5.4
	```

7. Apache2 インストールディレクトリ下の所有者：グループを apache:apache へ変更
8. httpd.conf の置き換え
9. httpd サービススクリプトの配置
10. httpd の service 登録（OS 起動時の自動起動）

## Attributes

``/etc/httpd/conf/httpd.conf`` で読み込まれる

|key|Type|Description|Default|Note|
|:---|:---|:---|:---|:---|
|``['httpd']['server_admin']``|Email|サーバがクライアントに送るエラーメッセージに含める電子メールの アドレス|root@localhost|[公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#serveradmin)|
|``['httpd']['server_name']``|URL:PortNo|サーバが自分自身を示すときに使うホスト名とポート|www.example.com:80|[公式ドキュメント](https://httpd.apache.org/docs/2.2/ja/mod/core.html#servername)|

## Usage

#### apache2::2.4.18

Just include `apache2::2.4.18` in your node's `run_list` and settings for ``httpd``:

```json
{
     "httpd" : {
         "server_admin" : "root@localhost",
         "server_name" : "www.example.com:80",
     },
     "run_list": [
         "recipe[apache2::2.4.18]",
     ],
}
```

