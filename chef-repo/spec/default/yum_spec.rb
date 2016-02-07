require 'spec_helper'

# install fastestmirror plugin
# install yum-priorities plugin
packages = ['yum-plugin-fastestmirror','yum-plugin-priorities']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end
describe file('/etc/yum/pluginconf.d/fastestmirror.conf') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
    it { should contain 'include_only=.jp' }
end
    
# settings for the official repository
describe file('/etc/yum.repos.d/CentOS-Base.repo') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end

# add epel repository and settings
describe command('rpm -qa epel-release') do
    its(:stdout) { should match /^epel-release-6-8.noarch$/ }
end
describe file('/etc/yum.repos.d/epel.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'exclude=php* mysql*' }
    it { should contain 'enabled=0' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end
describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '644' }
end

# add rpmforge repository and settings
describe command('rpm -qa rpmforge-release') do
    its(:stdout) { should match /^rpmforge-release-0.5.3-1.el6.rf.x86_64$/ }
end
describe file('/etc/yum.repos.d/rpmforge.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'exclude=php* mysql*' }
    it { should contain 'enabled = 0' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end
describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-dag') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '644' }
end
describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-rpmforge-fabian') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '644' }
end

# add remi repository and settings
describe command('rpm -qa remi-release') do
    its(:stdout) { should match /^remi-release-6.6-2.el6.remi.noarch$/ }
end
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
describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-remi') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '644' }
end

#add official-mysql yum repository and settings
describe command('rpm -qa mysql-community-release') do
    its(:stdout) { should match /^mysql-community-release-el6-5.noarch$/ }
end
describe file('/etc/yum.repos.d/mysql-community.repo') do
    it { should be_file }
    it { should contain 'priority=10' }
    it { should contain 'enabled=1' }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end
describe file('/etc/pki/rpm-gpg/RPM-GPG-KEY-mysql') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_mode '644' }
end

