#
# Cookbook Name:: php56
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# Install PHP modules
%w{libxml2-devel libjpeg-devel libpng-devel gettext-devel openssl-devel}.each do |pkg|
	yum_package pkg do
		action [:install, :upgrade]
		# action :install
	end
end

# Install PHP modules
%w{re2c openssl-devel}.each do |pkg|
	yum_package pkg do
        options "--enablerepo=rpmforge"
		action [:install, :upgrade]
		# action :install
	end
end

# Install OpenSSL Source code
remote_file "/usr/local/src/openssl-1.0.2f.tar.gz" do
    source 'https://www.openssl.org/source/openssl-1.0.2f.tar.gz'
    action :create
end

execute "source compile OpenSSL" do
    user "root"
    command <<-EOH
        cd /usr/local/src
        tar -xvzf openssl-1.0.2f.tar.gz
        cd /usr/local/src/openssl-1.0.2f
        ./configure --prefix=/usr/local/openssl shared zlib
        make
        make install
        EOH
    action :run
    #only_if { ::File.exists?("/usr/local/src/php-5.6.17.tar.gz")}
end

# Install cURL Source code
package "libssl2-devel" do
	action [:install, :upgrade]
	# action :install
end

remote_file "/usr/local/src/curl-7.47.0.tar.gz" do
    source 'http://curl.haxx.se/download/curl-7.47.0.tar.gz'
    action :create
end

execute "source compile cURL" do
    user "root"
    command <<-EOH
        cd /usr/local/src
        tar -xvzf curl-7.47.0.tar.gz
        cd /usr/local/src/curl-7.47.0.tar.gz
        ./configure --prefix=/usr/local --with-ssl=/usr/local/openssl --with-libssh2
        make
        make install
        EOH
    action :run
    #only_if { ::File.exists?("/usr/local/src/php-5.6.17.tar.gz")}
end

# Install PHP Source code
remote_file "/usr/local/src/php-5.6.17.tar.gz" do
    source 'http://jp2.php.net/get/php-5.6.17.tar.gz/from/this/mirror'
    action :create
end

execute "source compile PHP" do
    user "root"
    command <<-EOH
        cd /usr/local/src
        tar -xvzf php-5.6.17.tar.gz
        cd /usr/local/src/php-5.6.17
        ./configure \
        --enable-mbstring \
        --with-apxs2=/usr/local/apache2/bin/apxs \
        --with-openssl=/usr/local/openssl \
        --with-kerberos \
        --with-curl=/usr/local/lib \
        --with-curlwrappers \
        --enable-zip \
        --enable-pdo \
        --with-gd \
        --with-png-dir=/usr/local \
        --with-jpeg-dir=/usr/local \
        --with-pdo-mysql \
        --with-gettext
        make
        make install
        EOH
    action :run
    only_if { ::File.exists?("/usr/local/src/php-5.6.17.tar.gz")}
end


## Place php.ini( for Development )
#template "/usr/local/lib/php.ini" do
#  source "5.6.17/php.ini-development.erb"
#  owner "root"
#  group "root"
#  mode 0644
#  only_if node['php']['development']
#end

## Place php.ini( for Production )
#template "/usr/local/lib/php.ini" do
#  source "5.6.17/php.ini-production.erb"
#  owner "root"
#  group "root"
#  mode 0644
#  not_node['php']['development']
#end


