#
# Cookbook Name:: users
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

data_ids = data_bag('users')
data_ids.each do |id|
	u = data_bag_item('users', id)
	user u['id'] do
		shell    u['shell']
		password u['password']
		supports :manage_home => true, :non_unique => false
		action   [:create]
	end

	# wheel グループへ追加
	if u['wheel'] then
		group "wheel" do
			append true
			members u['id']
			action :modify
		end
	else
		group "wheel" do
			append true
			excluded_members u['id']
			action :modify
		end
	end

	# SSH 公開鍵配置用のディレクトリ作成
	directory "/home/#{id}/.ssh" do
		owner u['id']
		group u['id']
		mode 0700
		action :create
		not_if { ::File.exists?("/home/#{id}/.ssh")}
	end

	# SSH 公開鍵の配置
	file "/home/#{id}/.ssh/authorized_keys" do
		owner u['id']
		mode 0600
		content u['sshkey']
		action :create
		not_if { ::File.exists?("/home/#{id}/.ssh/authrized_keys")}
	end
end

# sudo for members of the wheel grp.
template "/etc/sudoers" do
  source "sudoers.erb"
  owner "root"
  group "root"
  mode 0440
end

# su for members of the wheel grp.
template "/etc/pam.d/su" do
  source "su.erb"
  owner "root"
  group "root"
  mode 0644
end

























