#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# create docker user
user "docker" do
    shell    '/bin/bash'
    system  true
    action  :create
end

# create docker group
group "docker" do
    append true
    members 'docker'
    action :modify
end

# install docker
package "docker-io" do
    options "--enablerepo=epel"
	action [:install, :upgrade]
end

# regist docker
execute "regist docker" do
    user "root"
    command "chkconfig --add docker"
    action :run
end

