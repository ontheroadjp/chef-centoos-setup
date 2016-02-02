#
# Cookbook Name:: build_tools
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "yum"

# Install Build tools
packages = ['wget','tar','gcc','make','pcre','pcre-devel']
packages.each do | pkg |
    package pkg do
        action [:install, :upgrade]
    end
end
packages = ['gcc-c++','ccache']
packages.each do | pkg |
    package pkg do
        action [:install, :upgrade]
        options "--enablerepo=epel"
    end
end

# Create directory for ccache
directory('/root/.ccache') do
    owner 'root'
    group 'root'
    mode 0755
    action :create
end

