#
# Cookbook Name:: iptables
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# settings for iptables
template "/root/iptables_rules_setting.sh" do
  source "iptables_rules_setting.sh.erb"
  owner "root"
  group "root"
  mode 0700
end

execute "ipconfig_rules_setting" do
    user "root"
	command "sh /root/iptables_rules_setting.sh"
end

# settings for rsyslog 
template "/etc/rsyslog.conf" do
  source "rsyslog.conf.erb"
  owner "root"
  group "root"
  mode 0755
end

# settings for logrotate
template "/etc/logrotate.d/iptables" do
  source "iptables_logrotate.erb"
  owner "root"
  group "root"
  mode 0644
end


