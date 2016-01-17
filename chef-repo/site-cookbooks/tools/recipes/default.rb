#
# Cookbook Name:: tools
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

## Tools
#%w{vim-enhanced git}.each do |pkg|
#	package pkg do
#		action :install
#	end
#end

# -----------------------------------------------
# git のインストール
# -----------------------------------------------
package 'git' do
    action :install
    only_if {node['tools']['git']}
end

# -----------------------------------------------
# vim(vim-enhanced) のインストール
# -----------------------------------------------

# インストール済みの vim を削除
package 'vim-minimal' do
    action :remove
    only_if {node['tools']['vim']}
end

# インストール
package 'vim-enhanced' do
    action :install
    only_if {node['tools']['vim']}
end

# -----------------------------------------------
# vim-lua のインストール
# -----------------------------------------------

# インストール済みの vim を削除
package ['vim-minimal','vim-enhanced'] do
    action :remove
    only_if {node['tools']['vim-lua']}
end

# 必要なライブラリをインストール
%w{mercurial ncurses-devel lua lua-devel}.each do |pkg|
	package pkg do
		action :install
        only_if {node['tools']['vim-lua']}
	end
end

# vim ソースの DL & コンパイル & インストール
src_path = "#{Chef::Config[:file_cache_path]}"

directory src_path do
    recursive true
    action :create
end

execute "source compile vim w/lua" do
        user "root"
        command <<-EOH
            hg clone https://vim.googlecode.com/hg/ src_path
            cd src_path
            ./configure \
                --with-features=huge \
                --enable-multibyte \
                --enable-luainterp=dynamic \
                --enable-gpm \
                --enable-cscope \
                --enable-fontset
            make
            make install
            EOH
        action :run
        only_if {node['tools']['vim-lua']}
end


