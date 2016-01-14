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

service "sshd" do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

service "sshd" do
	  action :restart
end


