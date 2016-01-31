require 'spec_helper'

# Install PHP modules
packages = ['libmcrypt','libmcrypt-devel','libxml2-devel','libjpeg-turbo-devel','libpng-devel','gettext-devel','openssl-devel','libcurl-devel' ]
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install PHP modules
packages = ['re2c','openssl-devel']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install OpenSSL Source code
describe 'Installing Open SSL' do
    describe file('/usr/local/src/openssl-1.0.2f.tar.gz') do
        it { should be_file }
        its(:sha256sum) { should eq '932b4ee4def2b434f85435d9e3e19ca8ba99ce9a065a61524b429a9d5e9b2e9c' }
    end
    describe file('/usr/local/openssl') do
        it { should be_directory }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
    end
end

describe 'Installing cURL' do
    # Install cURL Source code
    describe package('libssh2-devel') do
        it { should be_installed }
    end
    describe file('/usr/local/src/curl-7.47.0.tar.gz') do
      it { should be_file }
        its(:md5sum) { should eq '5109d1232d208dfd712c0272b8360393' }
    end
    describe file('/usr/local/bin/curl') do
        it { should be_file }
        it { should be_owned_by 'root' }
    end
end

describe 'Installing PHP' do
    # Install PHP Source code
    describe file('/usr/local/src/php-5.6.17.tar.gz') do
        it { should be_file }
        its(:md5sum) { should eq '9cbf226d0b5d852e66a0b7272368ecea' }
        it { should be_owned_by 'root' }
    end
    describe file('/usr/local/bin/php') do
        it { should be_file }
        it { should be_owned_by 'root' }
    end
end



