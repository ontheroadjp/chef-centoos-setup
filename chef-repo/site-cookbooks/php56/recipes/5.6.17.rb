#
# Cookbook Name:: php56
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build_tools"
#include_recipe "openssl"

# Install PHP modules
%w{libmcrypt libmcrypt-devel libxml2-devel libjpeg-devel libpng-devel gettext-devel zlib-devel openssl-devel curl-devel}.each do |pkg|
#%w{libxml2-devel libjpeg-devel libpng-devel libmcrypt-devel gettext-devel curl-devel}.each do |pkg|
#%w{libxml2-devel libjpeg-devel libpng-devel libmcrypt-devel gettext-devel}.each do |pkg|
	yum_package pkg do
		action [:install, :upgrade]
        options "--enablerepo=epel"
	end
end

# for APC and something like this
%w{re2c}.each do |pkg|
	yum_package pkg do
        options "--enablerepo=rpmforge"
		action [:install, :upgrade]
		# action :install
	end
end

# -------------------------------------
# Install PHP Source code
# -------------------------------------
remote_file "/usr/local/src/php-5.6.17.tar.gz" do
    source 'http://jp2.php.net/get/php-5.6.17.tar.gz/from/this/mirror'
    not_if { ::File.exists?("/usr/local/src/php-5.6.17.tar.gz")}
    action :create
end
execute "PHP - Untarball" do
    cwd "/usr/local/src"
    user "root"
    command "tar -xvzf php-5.6.17.tar.gz"
    action :run
    only_if { ::File.exists?("/usr/local/src/php-5.6.17.tar.gz")}
    not_if { ::File.exists?("/usr/local/src/php-5.6.17")}
end
execute "PHP - Build.." do
    cwd "/usr/local/src/php-5.6.17"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command <<-EOH
        make clean
        ./buildconf --force
        ./configure \
        --with-apxs2=/usr/local/apache2/bin/apxs \
        --enable-opcache \
        --enable-mbstring \
        --with-png-dir=/usr/local \
        --with-jpeg-dir=/usr/local \
        --enable-zip=shared \
        --enable-ssl \
        --with-openssl \
        --with-kerberos \
        --with-curl \
        --with-curlwrappers \
        --enable-pdo \
        --with-pdo-mysql \
        --with-gd \
        --with-mcrypt \
        --with-gettext
        make -j8
        make install
        EOH
    action :run
end
#execute "PHP make" do
#    cwd "/usr/local/src/php-5.6.17"
#    user "root"
#    environment(
#        "USE_CCACHE" => "1",
#        "CCACHE_DIR" => "/root/.ccache",
#        "CC" => "ccache gcc",
#        "CXX" => "ccache g++"
#    )
#    command "make -j 4"
#    action :run
#end
#execute "PHP make install" do
#    cwd "/usr/local/src/php-5.6.17"
#    user "root"
#    command "make -j 4 install"
#    action :run
#end


# Place php.ini( for Development )
template "/usr/local/lib/php.ini" do
  source "5.6.17/php.ini-development.erb"
  owner "root"
  group "root"
  mode 0644
  #only_if node['php']['development']
end

## Place php.ini( for Production )
#template "/usr/local/lib/php.ini" do
#  source "5.6.17/php.ini-production.erb"
#  owner "root"
#  group "root"
#  mode 0644
#  not_node['php']['development']
#end


