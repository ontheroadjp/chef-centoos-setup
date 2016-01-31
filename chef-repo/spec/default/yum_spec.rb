require 'spec_helper'

# install fastestmirror plugin
# install yum-priorities plugin

packages = ['yum-plugin-fastestmirror','yum-plugin-priorities']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# settings for the official repository
describe file('/etc/yum.repos.d/CentOS-Base.repo') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end

#add official-mysql yum repository and settings
describe file('/etc/yum.repos.d/mysql-community.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'enabled=1' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end

# add epel repository and settings
describe file('/etc/yum.repos.d/epel.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'exclude=php* mysql*' }
    it { should contain 'enabled=0' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end

# add rpmforge repository and settings
describe file('/etc/yum.repos.d/rpmforge.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'exclude=php* mysql*' }
    it { should contain 'enabled = 0' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end

# add remi repository and settings
describe file('/etc/yum.repos.d/remi.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'exclude=mysql*' }
    it { should contain 'enabled=1' }
    it { should contain 'enabled=0' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end


