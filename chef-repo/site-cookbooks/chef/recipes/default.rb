#
# Cookbook Name:: chef
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Chef Development Kit のダウンロード
remote_file "#{Chef::Config[:file_cache_path]}/chefdk-0.10.0-1.el6.x86_64.rpm" do
	source 'https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.10.0-1.el6.x86_64.rpm'
	action :create
end

# Chef Development Kit のインストール
rpm_package "Chef Development Kit" do
	source "#{Chef::Config[:file_cache_path]}/chefdk-0.10.0-1.el6.x86_64.rpm"
	action :install
end

# Knife-solo のインストール
execute 'Install knife-solo' do
    user 'root'
    command 'chef gem install knife-solo'
end

