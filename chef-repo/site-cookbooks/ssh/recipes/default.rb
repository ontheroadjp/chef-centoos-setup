#
# Cookbook Name:: ssh
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

template "/etc/ssh/sshd_config" do
    source "sshd_config.erb"
    owner "root"
    group "root"
    mode 0600
end

if platform_family?('rhel') && node['platform_version'].to_i == 7 then
    template "/etc/firewalld/services/ssh.xml" do
        source "ssh.erb"
        owner "root"
        group "root"
        mode 0640
    end
end

service "sshd" do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

service "sshd" do
	  action :restart
end

