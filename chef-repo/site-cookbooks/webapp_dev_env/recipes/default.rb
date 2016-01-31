#
# Cookbook Name:: webapp_dev_env
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## Install ruby & rubygems
#yum_package ['ruby', 'rubygems'] do
#    action :install
#    not_if 'which gem'
#end
#
#execute 'update gem' do
#	command 'gem update --system'
#    only_if 'which gem'
#end

# Install Node.js
package ['nodejs'] do
    action :install
    options "--enablerepo=epel"
    not_if 'which node'
end

# Install npm
package ['npm'] do
    action :install
    options "--enablerepo=epel"
    not_if 'which npm'
end

# Install Bower
execute 'install_bower' do
	command 'npm install bower -g'
    not_if 'which bower'
end

# Install Gulp
execute 'install_gulp' do
	command 'npm install gulp -g'
    not_if 'which gulp'
end

# Install Composer
execute 'install_composer' do
    command 'curl -sS https://getcomposer.org/installer | php ;mv composer.phar /usr/local/bin/composer'
    not_if { ::File.exists?("/usr/local/bin/composer")}
end

# Install SASS
gem_package 'sass' do
    action :install
end




