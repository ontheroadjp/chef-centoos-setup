#
# Cookbook Name:: webmin
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

# Install webmin
remote_file "#{Chef::Config[:file_cache_path]}/webmin-1.780-1.noarch.rpm" do
	source 'http://download.webmin.com/download/yum/webmin-1.780-1.noarch.rpm'
	action :create
end
rpm_package "webmin-1.780-1.noarch" do
	source "#{Chef::Config[:file_cache_path]}/webmin-1.780-1.noarch.rpm"
	action :install
end
#template "/etc/webmin/miniserv.conf" do
#  source "miniserv.conf.erb"
#  owner "root"
#  group "root"
#  mode 0600
#end

# Regist service
execute "regist service" do
    user "root"
    command "chkconfig --add webmin"
    action :run
end
