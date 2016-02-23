#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# create docker group
group "docker" do
    action :modify
end


# install docker
if platform_family?('rhel') && node['platform_version'].to_i == 6 then
    package "docker-io" do
        options "--enablerepo=epel"
    	action [:install, :upgrade]
    end
elsif platform_family?('rhel') && node['platform_version'].to_i == 7 then
    package "docker-io" do
    	action [:install, :upgrade]
    end
end

# Start docker
service "docker" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if {node['service']['docker']}
end


