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
template "/etc/webmin/config" do
  source "config.erb"
  owner "root"
  group "root"
  mode 0644
end

# Start webmin
service "webmin" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    #only_if { ::File.exists?("/etc/rc.d/init.d/httpd")}
    only_if {node['service']['webmin']}
end

#if platform_family?('rhel') && node['platform_version'].to_i == 6 then
#    execute "regist service" do
#        user "root"
#        command "chkconfig --add webmin"
#        action :run
#    end
#elsif platform_family?('rhel') && node['platform_version'].to_i == 7 then
#    execute "regist service" do
#        user "root"
#        command "systemctl enable webmin"
#        action :run
#    end
#end
