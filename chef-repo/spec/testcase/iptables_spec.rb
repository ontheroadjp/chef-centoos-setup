require 'serverspec' 

# settings for iptables
describe file('/root/iptables_rules_setting.sh') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 700 }
end


######################################################################
######                      ポリシーの設定                      ######
######################################################################

describe iptables do
    it { should have_rule('-P INPUT DROP') }
    it { should have_rule('-P OUTPUT ACCEPT') }
    it { should have_rule('-P FORWARD DROP') }
end

######################################################################
######                     不正アクセス対策                     ######
######################################################################

# --------------------------------------------------------------------
# IP Spoofing 対策（外部（WAN側）からプライベートIPアドレスに成りすました通信を破棄）
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -i eth0 -s 127.0.0.1/8 -j DROP') }        # ループバック
	it { should have_rule('-A INPUT -i eth0 -s 10.0.0.0/8 -j DROP') }         # クラスAのプライベートアドレス
	it { should have_rule('-A INPUT -i eth0 -s 172.16.0.0/12 -j DROP') }      # クラスBのプライベートアドレス
	it { should have_rule('-A INPUT -i eth0 -s 192.168.0.0/16 -j DROP') }     # クラスCのプライベートアドレス
	it { should have_rule('-A INPUT -i eth0 -s 192.168.0.0/24  -j DROP') }    # クラスCのプライベートアドレス
end
 
# --------------------------------------------------------------------
# Ping of Death & Ping Flood 対策
# Ping 応答を1秒間に1セット（Ping は通常4回で1セット）に制限し、さらに 85 byte 以上のパケットを破棄
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-N PING_ATTACK') }
	it { should have_rule('-A PING_ATTACK -p icmp --icmp-type 8 -m length --length :85 -m limit --limit 1/s --limit-burst 4 -j ACCEPT') }
	it { should have_rule('-A PING_ATTACK -j LOG --log-prefix "[IPTABLES PINGATTACK] : " --log-level=debug') }
	it { should have_rule('-A PING_ATTACK -j DROP') }
	it { should have_rule('-A INPUT -p icmp --icmp-type 8 -j PING_ATTACK') }
end
 
# --------------------------------------------------------------------
# Smurf 対策 + 不要ログ破棄（ブロードキャストからのパケットを破棄）
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -d 255.255.255.255 -j DROP') }
	it { should have_rule('-A INPUT -d 224.0.0.1 -j DROP') }
end

BCAST=`ifconfig | grep Bcast | sed -e 's/^ *//' | cut -f4 -d' ' | sed 's/Bcast://'`

describe iptables do
	it { should have_rule('-A INPUT -d $BCAST -j DROP') }
end

		# --------------------------------------------------------------------
		# Smurf の踏み台対策（ブロードキャスト宛の Ping に応答しない）
		# --------------------------------------------------------------------
		#sysctl -w net.ipv4.icmp_echo_ignore_broadcasts=1 > /dev/null
		#
		## サーバー再起動後にも有効になるように /etc/sysctl.conf を書き換える
		#sed -i '/# Disable Broadcast Ping/d' /etc/sysctl.conf
		#sed -i '/net.ipv4.icmp_echo_ignore_broadcasts/d' /etc/sysctl.conf
		#echo "# Disable Broadcast Ping" >> /etc/sysctl.conf
		#echo "net.ipv4.icmp_echo_ignore_broadcasts=1" >> /etc/sysctl.conf
 
		# --------------------------------------------------------------------
		# SYN flood 対策（SYN cookies の有効化）
		# --------------------------------------------------------------------
		#sysctl -w net.ipv4.tcp_syncookies=1 > /dev/null
		#
		## サーバー再起動後にも有効になるように /etc/sysctl.conf を書き換える
		#sed -i '/# Enable SYN Cookie/d' /etc/sysctl.conf
		#sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
		#echo "# Enable SYN Cookie" >> /etc/sysctl.conf
		#echo "net.ipv4.tcp_syncookies=1" >> /etc/sysctl.conf
 
# --------------------------------------------------------------------
# Auth/IDENT用の113番ポートは拒否（DROP ではなく REJECT）
# 参考：http://unixluser.org/techmemo/ident/
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -p tcp --dport 113 -i eth0 -j REJECT --reject-with tcp-reset') }
 end
 
		# --------------------------------------------------------------------
		# 拒否IPリスト（/root/deny_ip）があれば、そこに記載されたIPを拒否
		# --------------------------------------------------------------------
		#if [ -s /root/deny_ip ]; then
		#    for ip in `cat /root/deny_ip`
		#    do
		#        iptables -I INPUT -s $ip -j DROP') }
		#    done
		#fi
 
# --------------------------------------------------------------------
# 特定の国からのアクセスを許可するための ACCEPT_COUNTRY_FILTER チェーン生成
# (下記は、日本とアメリカからのみアクセスを許可)
# --------------------------------------------------------------------
#if [ -s /tmp/iplist ]; then
#     iptables -N ACCEPT_COUNTRY_FILTER
#     sed -n 's/^\(JP\|US\)\t//p' /tmp/iplist | while read address;
#     do
#          iptables -A ACCEPT_COUNTRY_FILTER -s $address -j ACCEPT') }
#     done
#fi

# --------------------------------------------------------------------
# 特定の国からのアクセスを拒否するための DROP_COUNTRY_FILTER チェーン生成
# (下記は、中国/インド/エジプト/パキスタンからのアクセスを拒否)
# --------------------------------------------------------------------
#if [ -s /tmp/iplist ]; then
#     iptables -N DROP_COUNTRY_FILTER
#     sed -n 's/^\(CN\|IN\|EG\|PK\)\t//p' /tmp/iplist | while read address;
#     do
#          iptables -A DROP_COUNTRY_FILTER -s $address -j DROP') }
#     done
#     iptables -A INPUT -j DROP') }_COUNTRY_FILTER
#fi
 
# --------------------------------------------------------------------
# ステートフル・パケットインスペクション対応（正しいTCPと既に許可された接続を許可）
# 参考：http://www.atmarkit.co.jp/ait/articles/1001/06/news101.html
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -p tcp ! --tcp-flags SYN,RST,ACK SYN -m state --state NEW -j DROP') }
	it { should have_rule('-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT') }
end

######################################################################
######                      ポート開放                          ######
######################################################################

# --------------------------------------------------------------------
# lo（ループバックインターフェース）の許可
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -i lo -j ACCEPT') }
	it { should have_rule('-A OUTPUT -o lo -j ACCEPT') }
 end
# --------------------------------------------------------------------
# DNS （DDpS（DNS Amp）は適宜ログを取り、60秒に5回以上のアクセスで遮断）
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule(' -N DNSAMP') }
	it { should have_rule('-A DNSAMP -m recent --name dnsamp --set') }
	it { should have_rule('-A DNSAMP -m recent --name dnsamp --rcheck --seconds 60 --hitcount 5 -j LOG --log-prefix "[IPTABLES DNSAMP] : " --log-level=debug') }
	it { should have_rule('-A DNSAMP -m recent --name dnsamp --rcheck --seconds 60 --hitcount 5 -j DROP') }
	it { should have_rule('-A DNSAMP -j ACCEPT') }
	it { should have_rule('-A INPUT -p udp -m state --state NEW --dport 53 -i eth0 -j DNSAMP') }
	it { should have_rule('-A INPUT -p tcp -m state --state NEW --dport 53 -j ACCEPT') }
end

# --------------------------------------------------------------------
# SSH（1時間に5回までの接続に制限. 1時間経つごとに1つリミットを解除）
# --------------------------------------------------------------------
#iptables -A INPUT -p tcp -m state --state NEW --dport 10022 -m hashlimit --hashlimit-burst 10 --hashlimit 1/h --hashlimit-mode srcip --hashlimit-htable-expire 3600000 --hashlimit-name ssh-limit -j ACCEPT') }

# --------------------------------------------------------------------
# SSH（接続制限なし）
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -p tcp -m state --state NEW --dport 10022 -j ACCEPT') }
end

		# --------------------------------------------------------------------
		# 80	: HTTP
		# 483	: HTTPS(http protocol over TLS/SSL) 
		# 25	: SMTP
		# 465	: SMTPs
		# 587	: SMTP（Submission port）
		# 110	: POP3
		# 995	: POP3s(imap4 over TLS/SSL)
		# 143	: IMAP4
		# 993	: IMAP4s(pop3 over TLS/SSL)
		# --------------------------------------------------------------------

		# アクセス国制限なく解放するポート番号をスペース区切りで指定する
		#SERVICE_PORTS=(80 483)
		#for port in ${SERVICE_PORTS[@]}; do
		#    iptables -A INPUT -p tcp --dport ${port} -j ACCEPT') }
		#done

		# 特定の国からの接続のみを許可するポート番号をスペース区切りで指定する
		#SERVICE_PORTS_RESTRICTED()
		#for port in ${SERVICE_PORTS_RESTRICTED[@]}; do
		#    iptables -A INPUT -p tcp --dport ${port} -j ACCEPT') }_COUNTRY_FILTER
		#done

# --------------------------------------------------------------------
# これまでの条件に一切該当しない通信を記録して破棄
# --------------------------------------------------------------------
describe iptables do
	it { should have_rule('-A INPUT -m limit --limit 1/s -j LOG --log-prefix "[IPTABLES DROP INPUT] : " --log-level=debug') }
	it { should have_rule('-A INPUT -j DROP') }
	it { should have_rule('-A FORWARD -m limit --limit 1/s -j LOG --log-prefix "[IPTABLES DROP FORWARD] : " --log-level=debug') }
	it { should have_rule('-A FORWARD -j DROP') }
end

		# --------------------------------------------------------------------
		# 設定を保存してiptablesを起動
		# --------------------------------------------------------------------
		#/etc/rc.d/init.d/iptables save
		#/etc/rc.d/init.d/iptables start


# ------------------------------------------------------------------------------

# settings for rsyslog
describe file('/etc/rsyslog.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
    it { should contain ':msg, contains, "IPTABLES PINGATTACK"    -/var/log/iptables/ping-attack.log' }
    it { should contain ':msg, contains, "IPTABLES DNSAMP"       -/var/log/iptables/dnsamp.log' }
    it { should contain ':msg, contains, "IPTABLES DROP INPUT"   -/var/log/iptables/input-drop.log' }
    it { should contain ':msg, contains, "IPTABLES DROP FORWARD"   -/var/log/iptables/forward-drop.log' }
end

# settings for logrotate
describe file('/etc/logrotate.d/iptables') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    it { should contain 'weekly' }
    it { should contain 'rotate 4' }
    it { should contain '/etc/init.d/iptables reload > /dev/null 2> /dev/null || true' }
end


