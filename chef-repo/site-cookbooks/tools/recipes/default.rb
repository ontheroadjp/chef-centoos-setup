#
# Cookbook Name:: tools
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# Tools
%w{vim-enhanced git}.each do |pkg|
	package pkg do
		action :install
	end
end

