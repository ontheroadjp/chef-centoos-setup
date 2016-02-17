#
# Cookbook Name:: iptables
# Recipe:: flush
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# settings for iptables
execute "ipconfig_rules_setting" do
    user 'root'
	command "iptables --flush && /etc/rc.d/init.d/iptables save"
end



