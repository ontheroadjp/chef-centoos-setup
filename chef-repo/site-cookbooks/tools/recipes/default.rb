#
# Cookbook Name:: tools
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Tools
%w{vim-enhanced git}.each do |pkg|
	package pkg do
		action :install
	end
end

