#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# MySQL
%w{mysql mysql-server mysql-devel}.each do |pkg|
	package pkg do
		action :install
    options "--enablerepo=remi --enablerepo=remi-php55"
	end
end

## phpMyAdmin
#%w{phpMyAdmin}.each do |pkg|
#  package pkg do
#    # action [:install, :upgrade]
#    action :install
#    options "--enablerepo=remi --enablerepo=remi-php55"
#  end
#end

