require 'spec_helper'


# Install Docker Compose
describe file('/etc/ssh/sshd_config') do
    it { should be_file }
    it { should be_owned_by 'root'}
    it { should be_grouped_into 'root'}
    it { should be_mode '600' }
    its(:stdout) { should match /^Port 10022$/ }
end

if platform_family?('rhel') && node['platform_version'].to_i == 7 then
    describe file('/etc/firewalld/service/ssh.xml') do
        it { should be_file }
        it { should be_owned_by 'root'}
        it { should be_grouped_into 'root'}
        it { should be_mode '640' }
        its(:stdout) { should match /<port protocol="tct" port="10022"\/>/ }
    end
end


