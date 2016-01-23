#
# Cookbook Name:: php56
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# Install PHP modules
%w{libxml2-devel libjpeg-devel libpng-devel gettext gettext-devel}.each do |pkg|
	yum_package pkg do
		action [:install, :upgrade]
		# action :install
	end
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
        --enable-zip \
        --enable-pdo \
        --with-gd \
        --with-png-dir=/usr/local \
        --with-jpeg-dir=/usr/local \
        --with-pdo-mysql \
        --with-openssl \
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


