#
# Cookbook Name:: jenkins
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install Java
packages = ['java-1.7.0-openjdk','java-1.7.0-openjdk-devel']
packages.each do | pkg |
    package pkg do
        action :install
    end
end

# Add Repository
execute 'Regist Jenkins repo' do
    cwd "/etc/yum.repos.d"
    user "root"
    command <<-EOH
        curl -OL http://pkg.jenkins-ci.org/redhat/jenkins.repo
        rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
        EOH
    action :run
end
template "/etc/yum.repos.d/jenkins.repo" do
  source "jenkins.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# Install Jenkins
package 'jenkins' do
    action [:install, :upgrade]
    options '--enablerepo=jenkins'
end
template "/etc/sysconfig/jenkins" do
  source "jenkins.erb"
  owner "root"
  group "root"
  mode 0600
end
group "wheel" do
    append true
    members 'jenkins'
    action :modify
end

# set sudoers
template "/etc/sudoers.d/jenkins" do
  source "jenkins_sudoers.erb"
  owner "root"
  group "root"
  mode 0440
end

# Start Jenkins
service "jenkins" do
  action [:start, :enable]
  supports :status => true, :restart => true, :reload => true
  only_if { ::File.exists?("/etc/rc.d/init.d/jenkins")}
end

