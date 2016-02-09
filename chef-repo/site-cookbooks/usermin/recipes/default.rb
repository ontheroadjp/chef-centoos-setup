#
# Cookbook Name:: usermin
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{
    perl
    perl-DBD-MySQL
    perl-Net-SSLeay
    perl-Authen-PAM
}.each do | pkg |
    package pkg do
        action :install
        options '--enablerepo=epel'
    end
end

# Install usermin
remote_file "#{Chef::Config[:file_cache_path]}/usermin-1.690-1.noarch.rpm" do
	source 'http://download.webmin.com/download/yum/usermin-1.690-1.noarch.rpm'
	action :create
end
rpm_package "usermin-1.690-1.noarch.rpm" do
	source "#{Chef::Config[:file_cache_path]}/usermin-1.690-1.noarch.rpm"
	action :install
end
template "/etc/usermin/config" do
  source "config.erb"
  owner "root"
  group "root"
  mode 0755
end

# Regist service
execute "regist service" do
    user "root"
    command "chkconfig --add usermin"
    action :run
end

