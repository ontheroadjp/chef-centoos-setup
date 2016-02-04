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
# ctags のインストール
# -----------------------------------------------
package 'ctags' do
    action :install
    only_if {node['tools']['ctags']}
end

# -----------------------------------------------
# gettext のインストール
# -----------------------------------------------
package 'gettext' do
    action :install
    only_if {node['tools']['gettext']}
end

# -----------------------------------------------
# htop のインストール
# -----------------------------------------------
package 'htop' do
    action :install
    options "--enablerepo=epel"
    only_if {node['tools']['htop']}
end

# -----------------------------------------------
# vim(vim-enhanced) のインストール
# -----------------------------------------------
package 'vim-enhanced' do
    action :install
    only_if {node['tools']['vim']}
end

# -----------------------------------------------
# vim-lua のインストール
# -----------------------------------------------

# インストール済みの vim を削除
package ['vim-enhanced'] do
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
    only_if {node['tools']['vim-lua']}
end

#remote_file "/usr/local/src/apr-1.5.2.tar.gz" do
#    source 'http://ftp.yz.yamagata-u.ac.jp/pub/network/apache//apr/apr-1.5.2.tar.gz'
#    action :create
#    not_if { ::File.exists?("/usr/local/src/apr-1.5.2.tar.gz")}
#end
#execute "Un tarball" do
#    cwd "/usr/local/src"
#    user "root"
#    command "tar -xvzf apr-1.5.2.tar.gz"
#    action :run
#    only_if { ::File.exists?("/usr/local/src/apr-1.5.2.tar.gz")}
#    not_if { ::File.exists?("/usr/local/src/apr-1.5.2")}
#end
#execute "APR ./configure" do
#    cwd "/usr/local/src/apr-1.5.2"
#    user "root"
#    environment(
#        "USE_CCACHE" => "1",
#        "CCACHE_DIR" => "/root/.ccache"
#    )
#    command "./configure --prefix=/opt/apr/apr-1.5.2"
#    action :run
#end
#execute "APR make" do
#    cwd "/usr/local/src/apr-1.5.2"
#    user "root"
#    environment(
#        "USE_CCACHE" => "1",
#        "CCACHE_DIR" => "/root/.ccache"
#    )
#    command "make -j 4"
#    action :run
#end
#execute "APR make install" do
#    cwd "/usr/local/src/apr-1.5.2"
#    user "root"
#    command "make -j 4 install"
#    action :run
#end

execute "source compile vim w/lua" do
   user "root"
   command <<-EOH
       ./buildconf --force
       make clean
       hg clone https://vim.googlecode.com/hg/ src_path
       cd src_path
       ./configure \
           --with-features=huge \
           --enable-multibyte \
           --enable-luainterp=dynamic \
           --enable-gpm \
           --enable-cscope \
           --enable-fontset
           2>&1 | tee log_configure.txt
           make -j8 2>&1 | tee log_make.txt
           make install 2>&1 | tee log_make_install.txt
       EOH
   action :run
   only_if {node['tools']['vim-lua']}
end


