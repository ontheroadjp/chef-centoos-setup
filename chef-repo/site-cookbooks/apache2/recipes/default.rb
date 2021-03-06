#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# Apache2.2.15
%w{httpd httpd-devel}.each do |pkg|
	package pkg do
		# action [:install, :upgrade]
		action :install
		# version '2.2.15-47.el6.centos.1'
	end
end

template "/etc/httpd/conf/httpd.conf" do
  source "httpd.conf.erb"
  owner "apache"
  group "apache"
  mode 0644
end

service "httpd" do
  action [:start, :enable]
  supports :status => true, :restart => true, :reload => true
end
