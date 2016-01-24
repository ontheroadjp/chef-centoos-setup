#
# Cookbook Name:: dotfiles
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

git "/root/dotfiles" do
    repository node[:dotfiles][:git_repository]
    revision node[:dotfiles][:git_revision]
    action :sync
end

execute "deploy dotfiles" do
    user "root"
    command <<-EOH
        sh /root/dotfiles/install.sh
    EOH
    action :run
end


