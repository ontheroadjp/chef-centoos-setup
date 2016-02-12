#
# Cookbook Name:: service
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Start apache
service "httpd" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/httpd")}
    only_if {node['service']['httpd']}
end

# Start MySQL
service "mysqld" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/mysqld")}
    only_if {node['service']['mysqld']}
end

# Start webmin
service "webmin" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/webmin")}
    only_if {node['service']['webmin']}
end

# Start usermin
service "usermin" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/usermin")}
    only_if {node['service']['usermin']}
end

# Start Jenkins
service "jenkins" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/jenkins")}
    only_if {node['service']['jenkins']}
end

# Start docker
service "docker" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/docker")}
    only_if {node['service']['docker']}
end



