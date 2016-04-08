require 'spec_helper'
require 'ohai'

ohai = Ohai::System.new
ohai.all_plugins


if ohai[:platform_family] == 'rhel' && ohai[:platform_version].to_i == 6 then
    # Install ntpd
    packages = ['ntp']
    packages.each do |pkg|
        describe package("#{pkg}") do
            it { should be_installed }
        end
    end
    describe file('/etc/ntp.conf') do
        it { should be_file }
        it { should be_owned_by 'root'}
        it { should be_owned_by 'root'}
        it { should be_mode '644'}
    end
    
    # service script
    describe file('/etc/rc.d/init.d/ntpd') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode '755' }
    end
    describe command('chkconfig --list ntpd') do
        its(:stdout) { should match /0:off/ }
        its(:stdout) { should match /1:off/ }
        its(:stdout) { should match /2:on/ }
        its(:stdout) { should match /3:on/ }
        its(:stdout) { should match /4:on/ }
        its(:stdout) { should match /5:on/ }
        its(:stdout) { should match /6:off/ }
    end
    
    # service script
    describe service('ntpd'), :if => os[:family] == 'redhat' do
      it { should be_enabled }
    end
en
