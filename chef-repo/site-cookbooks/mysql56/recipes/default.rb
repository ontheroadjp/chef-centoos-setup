#
# Cookbook Name:: mysql56
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# install mysql community server
yum_package "mysql-community-server" do
  action :install
  version "5.6.27-2.el6"
  flush_cache [:before]
  options "--enablerepo=mysql56-community"
end

#template "/etc/my.cnf" do
#	source "my.cnf.erb"
#	owner "root"
#	group "root"
#	mode 0644
#end

service "mysqld" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end


