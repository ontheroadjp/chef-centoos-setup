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
%w{
    libmcrypt 
    libmcrypt-devel 
    libxml2-devel 
    libjpeg-devel 
    libpng-devel 
    gettext-devel 
    zlib-devel 
    openssl-devel 
    curl-devel
    bzip2-devel
}.each do |pkg|
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
execute "PHP make clean" do
    cwd "/usr/local/src/php-5.6.17"
    user "root"
    command "make clean"
    only_if { ::File.exists?("/usr/local/src/php-5.6.17/Makefile")}
    action :run
end
execute "PHP - ./configure" do
    cwd "/usr/local/src/php-5.6.17"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command <<-EOH
        ./configure \
        --prefix=/usr/local/php-5.6.17 \
        --with-config-file-path=/usr/local/php-5.6.17/etc \
        --with-config-file-scan-dir=/usr/local/php-5.6.17/etc/php.d \
        --with-layout=GNU \
        --enable-bcmath=shared \
        --enable-calendar=shared \
        --enable-dba=shared \
        --enable-exif=shared \
        --enable-ftp=shared \
        --enable-fpm=shared \
        --enable-mbstring=shared \
        --enable-opcache=shared \
        --enable-shmop=shared \
        --enable-sigchild=shared \
        --enable-soap=shared \
        --enable-sockets=shared \
        --enable-sqlite \
        --enable-sysvmsg=shared \
        --enable-wddx=shared \
        --enable-zip=shared \
        --with-apxs2=/usr/local/apache2/bin/apxs \
        --with-bz2=shared \
        --with-curl=shared \
        --with-fpm-user=apache \
        --with-fpm-group=apache \
        --with-gd=shared \
        --with-gettext=shared \
        --with-mcrypt=shared \
        --with-mysqli=shared \
        --with-openssl=shared \
        --with-pdo-mysql=shared \
        --with-xmlrpc=shared \
        --with-zlib=shared \
        2>&1 | tee log_configure.txt
        EOH
    action :run
end
execute "PHP make" do
    cwd "/usr/local/src/php-5.6.17"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command "make -j8 2>&1 | tee log_make.txt"
    action :run
end
execute "PHP make install" do
    cwd "/usr/local/src/php-5.6.17"
    user "root"
    command "make install 2>&1 | tee log_install.txt"
    action :run
end
execute 'PHP set sim links' do
    cwd "/usr/local/bin"
    user 'root'
    command "ln -fs " + node['php']['prefix'] + "/bin/* ./"
    action :run
end


# -------------------------------------
# Setup PHP configurations
# -------------------------------------

# Place php.ini
template node['php']['prefix'] + "/etc/php.ini" do
  source "5.6.17/php.ini-" + node['php']['mode'] + '.erb'
  owner "root"
  group "root"
  mode 0644
end

## Place php.ini( for Production )
#template "/usr/local/lib/php.ini" do
#  source "5.6.17/php.ini-production.erb"
#  owner "root"
#  group "root"
#  mode 0644
#  only_if node['php']['mode'] == 'production'
#end

# Set shared extensions
template node['php']['prefix'] + "/etc/set_php_shared_extension.sh" do
  source "5.6.17/set_php_shared_extension.sh.erb"
  owner "root"
  group "root"
  mode 0700
end
directory node['php']['prefix'] + "/etc/php.d" do
    user "root"
    group "root"
    mode 0755
    action :create
end
execute "PHP - set shared extensions" do
    cwd node['php']['prefix'] + "/etc"
    #cwd "/usr/local/php-5.6.17/etc"
    user "root"
    command "sh set_php_shared_extension.sh"
    action :run
    only_if { ::File.exists?(node['php']['prefix'] + "/etc/set_php_shared_extension.sh")}
end

# Set opcache production
template node['php']['prefix'] + "/etc/set_php_opcache_production.sh" do
  source "5.6.17/set_php_opcache_production.sh.erb"
  owner "root"
  group "root"
  mode 0700
end
directory "/var/lib/php" do
    user "root"
    group "root"
    mode 0644
    action :create
end
execute "PHP - set opcache production" do
    cwd node['php']['prefix'] + "/etc"
    user "root"
    command "sh set_php_opcache_production.sh"
    action :run
    only_if { ::File.exists?(node['php']['prefix'] + "/etc/set_php_opcache_production.sh")}
end

