#
# Cookbook Name:: yum
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# update
execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

# install yum-priorities
%w{yum-plugin-priorities}.each do |pkg|
  package pkg do
    action :install
  end
end

# settings for the official repository
template "/etc/yum.repos.d/CentOS-Base.repo" do
  source "CentOS-Base.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# add official-mysql yum repository
remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm" do
	source 'http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm'
	action :create
end

rpm_package "mysql-community-release" do
	source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm"
	action :install
end


# add epel repository and settings
bash 'add_epel' do
  user 'root'
  code <<-EOC
    rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
  EOC
  creates "/etc/yum.repos.d/epel.repo"
end

template "/etc/yum.repos.d/epel.repo" do
  source "epel.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# add rpmforge repository and settings
bash 'add_rpmforge' do
  user 'root'
  code <<-EOC
    rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/rpmforge.repo
  EOC
  creates "/etc/yum.repos.d/rpmforge.repo"
end

template "/etc/yum.repos.d/rpmforge.repo" do
  source "rpmforge.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# add remi repository and settings
bash 'add_remi' do
  user 'root'
  code <<-EOC
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo
  EOC
  creates "/etc/yum.repos.d/remi.repo"
end

template "/etc/yum.repos.d/remi.repo" do
  source "remi.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# install fastestmirror 
#yum_package "yum-fastestmirror" do
#  action :install
#end

# finally clean-up and update
execute "yum-clean_and_update" do
  user "root"
  command "yum update && yum update"
  action :run
end

