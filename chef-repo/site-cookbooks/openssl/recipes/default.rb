#
# Cookbook Name:: openssl
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build_tools"

# Install PHP modules
%w{libmcrypt libmcrypt-devel zlib-devel openssl-devel}.each do |pkg|
	package pkg do
		action [:install, :upgrade]
        options "--enablerepo=epel"
	end
end

# -------------------------------------
# Install OpenSSL Source code
# -------------------------------------
remote_file "/usr/local/src/openssl-1.0.2f.tar.gz" do
    source 'https://www.openssl.org/source/openssl-1.0.2f.tar.gz'
    not_if { ::File.exists?("/usr/local/src/openssl-1.0.2f.tar.gz")}
    action :create
end
execute "Un tarball" do
    cwd "/usr/local/src"
    user "root"
    command "tar -xvzf openssl-1.0.2f.tar.gz"
    action :run
    only_if { ::File.exists?("/usr/local/src/openssl-1.0.2f.tar.gz")}
    not_if { ::File.exists?("/usr/local/src/openssl-1.0.2f")}
end
execute "OpenSSL ./config" do
    cwd "/usr/local/src/openssl-1.0.2f"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"
    )
    command "./config --prefix=/usr/local/openssl shared zlib"
    action :run
end
#execute "OpenSSL make clean" do
#    cwd "/usr/local/src/openssl-1.0.2f"
#    user "root"
#    command "make clean"
#    action :run
#end
execute "OpenSSL make" do
    cwd "/usr/local/src/openssl-1.0.2f"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"
    )
    command "make -j 4"
    action :run
end
execute "OpenSSL make install" do
    cwd "/usr/local/src/openssl-1.0.2f"
    user "root"
    command "make install"
    action :run
end

# -------------------------------------
# Set Shared library path
# -------------------------------------
template "/etc/ld.so.conf.d/openssl.conf" do
    source "openssl.conf.erb"
    user 'root'
    group 'root'
    mode 0644
end



