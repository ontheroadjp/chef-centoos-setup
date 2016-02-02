require 'spec_helper'

# Install PHP modules
describe 'Installing cURL' do
    # Install cURL Source code
    packages = ['libssh2-devel','libcurl-devel']
    packages.each do | pkg |
        describe package("#{pkg}") do
            it { should be_installed }
        end
    end

    describe file('/usr/local/src/curl-7.47.0.tar.gz') do
      it { should be_file }
        its(:md5sum) { should eq '5109d1232d208dfd712c0272b8360393' }
    end
    describe file('/usr/local/bin/curl') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 755 }
    end
end

