# sakuravps_tuning Cookbook

## Description

* 不要なデーモンを停止する
* 不要なパッケージを削除する

## Requirements

* 特になし

## Attributes

* 特になし

## Stopped Daemon

|No.|Daemon Name|Description|
|:---|:---|:---|
|1|auditd||
|2|autofs||
|3|avahi-daemon||
|4|bluetooth||
|5|cups||
|6|firstboot||
|7|gpm||
|8|haldaemon||
|9|hidd||
|10|isdn||
|11|kudzu||
|12|lvm2-monitor||
|13|mcstrans||
|14|mdmonitor||
|15|messagebus||
|16|netfs||
|17|nfslock||
|18|pcscd||
|19|portmap||
|20|rawdevices||
|21|restorecond||
|22|rpcgssd||
|23|rpcidmapd||
|24|smartd||
|25|xfs||
|26|yum-updatesd||
 

## Removed Package

|No.|Package Name|Description|
|:---|:---|:---|
|1|cups|プリントサーバー|
|2|kudzu|ハードウェア構成変更検出|
|3|wireless-tools|無線 LAN 関連|
|4|wpa_supplicant|無線 LAN 関連|
|5|pcmciautils|ノートPC等のPCカードスロット用ドライバ|
|6|irda-utils|赤外線通信用|
|7|ccid|スマートカード用|
|8|gtk2|デスクトップ環境|
|9|bluez-gnome|BlueTooth 用|
|10|bluez-utils|BlueTooth 用|
|11|blues-libs|BlueTooth 用|
|12|alsa-lib|サウンド再生|

* [参考：http://www4413u.sakura.ne.jp/wiki/28.html](http://www4413u.sakura.ne.jp/wiki/28.html)

## Usage

#### sakuravps_tuning::default
TODO: Write usage instructions for each cookbook.


```json
{
  "name":"my_node",
  "run_list": [
    "recipe[sakuravps_tuning]"
  ]
}
```

## Note

