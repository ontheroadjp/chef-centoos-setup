#
# Cookbook Name:: mysql56
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# install mysql community server
yum_package "mysql-community-server" do
  action :install
  version "5.6.28-2.el6"
  flush_cache [:before]
  options "--enablerepo=mysql56-community"
end

#template "/etc/my.cnf" do
#	source "my.cnf.erb"
#	owner "root"
#	group "root"
#	mode 0644
#end

## phpMyAdmin
#%w{phpMyAdmin}.each do |pkg|
#  package pkg do
#    # action [:install, :upgrade]
#    action :install
#    options "--enablerepo=remi --enablerepo=remi-php55"
#  end
#end
