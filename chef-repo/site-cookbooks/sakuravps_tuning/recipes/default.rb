#
# Cookbook Name:: sakuravps_tuning
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

execute "stop_daemon" do
	command <<-EOH
		chkconfig auditd off > /dev/null
		chkconfig autofs off > /dev/null
		chkconfig avahi-daemon off > /dev/null
		chkconfig bluetooth off > /dev/null
		chkconfig cups off > /dev/null
		chkconfig firstboot off > /dev/null
		chkconfig gpm off > /dev/null
		chkconfig haldaemon off > /dev/null
		chkconfig hidd off > /dev/null
		chkconfig isdn off > /dev/null
		chkconfig kudzu off > /dev/null
		chkconfig lvm2-monitor off > /dev/null
		chkconfig mcstrans off > /dev/null
		chkconfig mdmonitor off > /dev/null
		chkconfig messagebus off > /dev/null
		chkconfig netfs off > /dev/null
		chkconfig nfslock off > /dev/null
		chkconfig pcscd off > /dev/null
		chkconfig portmap off > /dev/null
		chkconfig rawdevices off > /dev/null
		chkconfig restorecond off > /dev/null
		chkconfig rpcgssd off > /dev/null
		chkconfig rpcidmapd off > /dev/null
		chkconfig smartd off > /dev/null
		chkconfig xfs off > /dev/null
		chkconfig yum-updatesd off > /dev/null

		yum -y remove cups > /dev/null
		yum -y remove kudzu > /dev/null
		yum -y remove wireless-tools > /dev/null
		yum -y remove wpa_supplicant > /dev/null
		yum -y remove pcmciautils > /dev/null
		yum -y remove irda-utils > /dev/null
		yum -y remove ccid > /dev/null
		yum -y remove gtk2 > /dev/null
		yum -y remove bluez-gnome > /dev/null
		yum -y remove bluez-utils > /dev/null
		yum -y remove blues-libs > /dev/null
		yum -y remove alsa-lib > /dev/null
	EOH
	action :run
end

# yum remove の簡単な説明
# 参考: http://www4413u.sakura.ne.jp/wiki/28.html
#
# cups：プリントサーバー
# kudzu：ハードウェア構成変更検出
# wireless-tools,wpa_supplicant：無線LAN関係
# pcmciautils：ノートPC等のPCカードスロット用ドライバ
# irda-utils：赤外線通信用
# ccid：スマートカード用
# gtk2：デスクトップ環境
# bluez-gnome,bluez-utils,bluez-libs：BlueTooth用
# alsa-lib：サウンド再生

