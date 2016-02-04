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
packages = ['autoconf','automake','libtool.x86_64','flex.x86_64','bison.x86_64','gcc.x86_64','make.x86_64','kernel-headers.x86_64','kernel-devel.x86_64']
packages.each do | pkg |
    package pkg do
        action [:install, :upgrade]
    end
end
packages = ['gcc-c++.x86_64','ccache']
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

