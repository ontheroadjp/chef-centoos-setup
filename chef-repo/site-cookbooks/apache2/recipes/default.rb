#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# Apache2
%w{httpd httpd-devel}.each do |pkg|
	package pkg do
		# action [:install, :upgrade]
		action :install
		# version '2.2.15-47.el6.centos.1'
	end
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, 'service[httpd]'
end

service "httpd" do
  action [:start, :enable]
  supports :status => true, :restart => true
end
