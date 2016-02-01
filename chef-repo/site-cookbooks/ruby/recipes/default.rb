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
    action :create
end

# Install rbenv
git 'install ruby' do
    repository 'git://github.com/sstephenson/rbenv.git'
    reference 'master'
    destination '/usr/local/rbenv'
    group 'rbenv'
    action :sync
end
dirs = ['/usr/local/rbenv/shims','/usr/local/rbenv/versions','/usr/local/rbenv/plugins' ]
dirs.each do | dir |
    directory dir do
        group "rbenv"
        mode 0755
        action :create
    end
end
#dirs = [ '/usr/local/rbenv','/usr/local/rbenv/shims','/usr/local/rbenv/versions','/usr/local/rbenv/plugins' ]
#dirs.each do | dir |
#    directory dir do
#        group "rbenv"
#        mode 0755
#        recursive true
#        action :create
#    end
#end

# Install ruby-build
git 'install ruby-build' do
    repository 'git://github.com/sstephenson/ruby-build.git'
    reference 'master'
    destination '/usr/local/rbenv/plugins/ruby-build'
    group 'rbenv'
    action :sync
end
#directory '/usr/local/rbenv/plugins/ruby-build' do
#    owner 'root'
#    group 'rbenv'
#    mode 0755
#    recursive true
#    action :create
#end

# Install rbenv-default-gems
git 'install ruby-default-gems' do
    repository 'git://github.com/sstephenson/rbenv-default-gems.git'
    reference 'master'
    destination '/usr/local/rbenv/plugins/rbenv-default-gems'
    group 'rbenv'
    action :sync
end
#directory '/usr/local/rbenv/plugins/rbenv-default-gems' do
#    owner 'root'
#    group 'rbenv'
#    mode 0755
#    recursive true
#    action :create
#end

# Set Environment variables
template '/etc/profile.d/rbenv.sh' do
    source 'default/rbenv.sh.erb'
    owner 'root'
    group 'root'
    mode 0644
end

# Set default-gems
template '/usr/local/rbenv/default-gems' do
    source 'default/default-gems.erb'
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

dirs = ['/usr/local/rbenv']
dirs.each do | dir |
    directory dir do
        owner 'root'
        group 'rbenv'
        mode 0755
        recursive true
        action :create
    end
end
