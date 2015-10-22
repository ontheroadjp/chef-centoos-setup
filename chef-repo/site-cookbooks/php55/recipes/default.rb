#
# Cookbook Name:: php55
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

# PHP5.5
%w{libmcrypt}.each do |pkg|
  package pkg do
    action [:install, :upgrade]
    # action :install
    options "--enablerepo=epel"
  end
end

#template "/etc/php.ini" do
#  source "php.ini.erb"
#  owner "root"
#  group "root"
#  mode 0644
#end

%w{php php-devel php-mbstring php-xml php-mcrypt php-gd php-pecl-xdebug php-opcache php-pecl-apcu php-fpm php-phpunit-PHPUnit php-mysqlnd}.each do |pkg|
  package pkg do
    action [:install, :upgrade]
    # action :install
    options "--enablerepo=remi --enablerepo=remi-php55"
  end
end

