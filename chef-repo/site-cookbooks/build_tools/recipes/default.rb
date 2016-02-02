#
# Cookbook Name:: build_tools
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Install Build tools
packages = ['wget','tar','make','pcre','pcre-devel']
packages.each do | pkg |
    package pkg do
        action [:install, :upgrade]
    end
end
packages = ['ccache']
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


#%w{wget tar gcc gcc-c++ make pcre pcre-devel}.each do |pkg|
#	package pkg do
#		action [:install, :upgrade]
#		# action :install
#	end
#end

