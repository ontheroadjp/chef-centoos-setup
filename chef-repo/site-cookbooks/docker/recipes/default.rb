#
# Cookbook Name:: docker
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## create docker user
#user "docker" do
#    shell    '/bin/false'
#    system  true
#    action  :create
#end
#
## create docker group
#group "docker" do
#    append true
#    members 'docker'
#    action :modify
#end

# create docker group
group "docker" do
    action :create
end

# install docker
if platform_family?('rhel') && node['platform_version'].to_i == 6 then
    package "docker-io" do
        options "--enablerepo=epel"
    	action [:install, :upgrade]
    end
elsif platform_family?('rhel') && node['platform_version'].to_i == 7 then

    # Add yum repository
    execute "Install Docker Engine" do
        user "root"
        command <<-EOH
            tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
enabled=0
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
            EOH
        action :run
    end

    # Install Docker engine
    package "docker-engine" do
        options "--enablerepo=dockerrepo"
        action [:install, :upgrade]
    end

    ## Add service script enabled LTS
    #template "/etc/systemd/system/docker.service" do
    #  source "docker.service.erb"
    #  owner "root"
    #  group "root"
    #  mode 0644
    #end
    
    # Add service script enabled LTS
    directory "/etc/systemd/system/docker.service.d" do
        owner "root"
        mode "0755"
        action :create
    end
    template "/etc/systemd/system/docker.service.d/docker.conf" do
      source "docker.conf.erb"
      owner "root"
      group "root"
      mode 0644
    end

    # Add Docker-TLS script
    execute "make docker dir" do
        user "root"
        command <<-EOH
            mkdir -p /root/docker_util
            EOH
        action :run
    end
    template "/root/docker_util/docker-tls.sh" do
      source "docker-tls.sh.erb"
      owner "root"
      group "root"
      mode 0700
    end
end

# Start docker
service "docker" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if {node['service']['docker']}
end

# Install Docker Compose 1.6.2
execute "Install Docker Compose" do
    user "root"
    command <<-EOH
        #curl -L https://github.com/docker/compose/releases/download/1.5.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        curl -L https://github.com/docker/compose/releases/download/1.6.2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
        #chmod +x /usr/local/bin/docker-compose
        chmod 0755 /usr/local/bin/docker-compose
        EOH
    action :run
end

# Install Docker Completion
execute "Install Docker Completion" do
    user "root"
    command <<-EOH
        curl -L https://raw.githubusercontent.com/docker/compose/$(docker-compose version --short)/contrib/completion/bash/docker-compose > /etc/bash_completion.d/docker-compose
        EOH
    action :run
end


