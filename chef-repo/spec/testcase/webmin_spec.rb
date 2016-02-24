require 'spec_helper'

# dependency
packages = ['perl','perl-DBD-MySQL','perl-Net-SSLeay','perl-Authen-PAM']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# template
describe command('rpm -qa | grep webmin') do
    its(:stdout) { should match /^webmin-1.780-1.noarch$/ }
end

# template
describe file('/etc/webmin/config') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
    its(:contain) { "lang=JP.UTF-8" }
end

# Regist service
describe service('webmin'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
end
describe command('chkconfig --list webmin') do
    its(:stdout) { should match /0:off/ }
    its(:stdout) { should match /1:off/ }
    its(:stdout) { should match /2:on/ }
    its(:stdout) { should match /3:on/ }
    its(:stdout) { should match /4:off/ }
    its(:stdout) { should match /5:on/ }
    its(:stdout) { should match /6:off/ }
end

