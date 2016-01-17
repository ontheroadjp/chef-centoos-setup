# iptables Cookbook

1. iptable の設定を行うレシピ
2. rsyslog によるログ取得
3. ログローテーションの設定

## iptables の設定内容

1. ポリシーの設定
2. 不正アクセス対策
	* IP Spoofing 対策
	* Ping Attack + Ping Flood 対策
	* Smurf 対策 + 不要ログの破棄
	* SYN flood 対策（SYN cookies の有効化）
	* Auth/IDENT 用のポート拒否
	* 拒否 IP リストに記載された IP アドレスからの接続拒否
	* ステートフル・パケットインスペクション対応
3. 接続許可
	* lo（ループバック） の許可
	* SSH 接続（接続元国制限&ハッシュリミットなし）
	* DNS（DDps:DNS Amp はログを取る）
	* HTTP（80番ポート）


## Requirements

* CentOS 6.5 or higher

## Attributes

#### iptables::default

|Key|Type|Description|Default|
|:---|:---|:---|:---|

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['iptables']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### iptables::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `iptables` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[iptables]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors


```
Chain INPUT (policy DROP)
target     prot opt source               destination         
DROP       all  --  loopback/8           anywhere            
DROP       all  --  10.0.0.0/8           anywhere            
DROP       all  --  172.16.0.0/12        anywhere            
DROP       all  --  192.168.0.0/16       anywhere            
DROP       all  --  192.168.0.0/24       anywhere            
PING_ATTACK  icmp --  anywhere             anywhere            icmp echo-request 
DROP       all  --  anywhere             255.255.255.255     
DROP       all  --  anywhere             all-systems.mcast.net 
DROP       all  --  anywhere             160.16.229.255      
REJECT     tcp  --  anywhere             anywhere            tcp dpt:auth reject-with tcp-reset 
DROP       tcp  --  anywhere             anywhere            tcp flags:!SYN,RST,ACK/SYN state NEW 
ACCEPT     all  --  anywhere             anywhere            state RELATED,ESTABLISHED 
ACCEPT     all  --  anywhere             anywhere            
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:10022 
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:ssh 
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:http 
DNSAMP     udp  --  anywhere             anywhere            state NEW udp dpt:domain 
ACCEPT     tcp  --  anywhere             anywhere            state NEW tcp dpt:domain 
ACCEPT     tcp  --  anywhere             anywhere            tcp dpt:http 
LOG        all  --  anywhere             anywhere            limit: avg 1/sec burst 5 LOG level debug prefix `[IPTABLES DROP INPUT] : ' 
DROP       all  --  anywhere             anywhere            

Chain FORWARD (policy DROP)
target     prot opt source               destination         
LOG        all  --  anywhere             anywhere            limit: avg 1/sec burst 5 LOG level debug prefix `[IPTABLES DROP FORWARD] : ' 
DROP       all  --  anywhere             anywhere            

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere            

Chain DNSAMP (1 references)
target     prot opt source               destination         
           all  --  anywhere             anywhere            recent: SET name: dnsamp side: source 
LOG        all  --  anywhere             anywhere            recent: CHECK seconds: 60 hit_count: 5 name: dnsamp side: source LOG level debug prefix `[IPTABLES DNSAMP] : ' 
DROP       all  --  anywhere             anywhere            recent: CHECK seconds: 60 hit_count: 5 name: dnsamp side: source 
ACCEPT     all  --  anywhere             anywhere            

Chain PING_ATTACK (1 references)
target     prot opt source               destination         
ACCEPT     all  --  anywhere             anywhere            length 0:85 limit: avg 1/sec burst 4 
LOG        all  --  anywhere             anywhere            LOG level debug prefix `[IPTABLES PINGATTACK] : ' 
DROP       all  --  anywhere             anywhere
```