#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#package install needed
packages = [ 'git','openssl-devel','readline-devel','zlib-devel','libcurl-devel' ]
packages.each do | pkg |
    package pkg do
        action [:install, :upgrade]
    end
end

# Create rbenv group
group 'rbenv' do
    append true
    action :modify
end

# Install rbenv
git 'install ruby' do
    repository 'git://github.com/sstephenson/rbenv.git /usr/local/rbenv'
    reference 'master'
    action :sync
end

dirs = [ '/usr/local/rbenv','/usr/local/rbenv/shims','/usr/local/rbenv/versions','/usr/local/rbenv/plugins' ]
dirs.each do | dir |
    directory dir do
        group 'rbenv'
        mode '755'
        action :create
    end
end

# Install ruby-build
git 'install ruby-build' do
    repository 'git://github.com/sstephenson/ruby-build.git /usr/local/rbenv/plugins/ruby-build'
    reference 'master'
    action :sync
end
directory '/usr/local/rbenv/plugins/ruby-build' do
    owner 'root'
    group 'rbenv'
    mode '755'
    action :create
end

# Install rbenv-default-gems
git 'install ruby-default-gems' do
    repository 'git://github.com/sstephenson/rbenv-default-gems.git /usr/local/rbenv/plugins/rbenv-default-gems'
    reference 'master'
    action :sync
end
directory '/usr/local/rbenv/plugins/rbenv-default-gems' do
    owner 'root'
    group 'rbenv'
    mode '755'
    action :create
end

# Set Environment variables
template '/etc/profile.d/rbenv.sh' do
    sourc 'default/rbenv.sh.erb'
    owner 'root'
    group 'root'
    mode 0644
end

# Set default-gems
template '/usr/local/rbenv/default-gems' do
    sourc 'default/default-gems'
    owner 'root'
    group 'root'
    mode 0644
end

# Install Ruby
# Use ruby installed
execute 'Install ruby' do
    user 'root'
    command <<-EOH
        source /etc/profile.d/rbenv.sh
        rbenv install 2.3.0
        rbenv global 2.3.0
        EOH
    action :run
end

