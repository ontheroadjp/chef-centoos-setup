#
# Cookbook Name:: yum
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# ---------------------------------------
# install fastestmirror plugin 
# ---------------------------------------
yum_package "yum-fastestmirror" do
  action :install
end

# ---------------------------------------
# install yum-priorities plugin
# ---------------------------------------
%w{yum-plugin-priorities}.each do |pkg|
  package pkg do
    action :install
  end
end
template "/etc/yum/pluginconf.d/fastestmirror.conf" do
    source "fastestmirror.conf.erb"
    owner "root"
    group "root"
    mode 0644
end

# ---------------------------------------
# official repository
# ---------------------------------------
template "/etc/yum.repos.d/CentOS-Base.repo" do
  source "CentOS-Base.repo.erb"
  owner "root"
  group "root"
  mode 0644
end

# ---------------------------------------
# official-mysql
# ---------------------------------------
remote_file "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm" do
	source 'http://repo.mysql.com/mysql-community-release-el6-5.noarch.rpm'
	action :create
end
rpm_package "mysql-community-release" do
	source "#{Chef::Config[:file_cache_path]}/mysql-community-release-el6-5.noarch.rpm"
	action :install
end
template "/etc/yum.repos.d/mysql-community.repo" do
  source "mysql-community.repo.erb"
  owner "root"
  group "root"
  mode 0644
end
#template "/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql" do
#	source "RPM-GPG-KEY-mysql.erb"
#	owner "root"
#	group "root"
#	mode 0644
#end

# ---------------------------------------
# epel repository
# ---------------------------------------
if platform_family?('rhel') && node['platform_version'].to_i == 6 then
    remote_file "#{Chef::Config[:file_cache_path]}/epel-release-6-8.noarch.rpm" do
    	source 'http://dl.fedoraproject.org/pub/epel/6/i386/epel-release-6-8.noarch.rpm'
    	action :create
    end
    rpm_package "epel-release-6-8.noarch.rpm" do
    	source "#{Chef::Config[:file_cache_path]}/epel-release-6-8.noarch.rpm"
    	action :install
    end
    template "/etc/yum.repos.d/epel.repo" do
      source "epel_6.repo.erb"
      owner "root"
      group "root"
      mode 0644
    end
elsif platform_family?('rhel') && node['platform_version'].to_i == 7 then
    package 'epel-release' do
        action [:install,:upgrade]
    end
    #execute 'GPG-KEY-EPEL' do
    #    user 'root'
    #    command 'rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7'
    #    action :run
    #end
    template "/etc/yum.repos.d/epel.repo" do
      source "epel_7.repo.erb"
      owner "root"
      group "root"
      mode 0644
    end
end

# ---------------------------------------
# rpmforge repository
# ---------------------------------------
execute 'add_rpmforge' do
  user 'root'
  command <<-EOC
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

# ---------------------------------------
# remi repository
# ---------------------------------------
execute 'add_remi' do
  user 'root'
  command <<-EOC
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

# ---------------------------------------
# finally yum update
# ---------------------------------------
execute "yum-update" do
  user "root"
  command "yum -y update"
  action :run
end

