require 'spec_helper'

# Install PHP modules
packages = ['libmcrypt','libmcrypt-devel','libxml2-devel','libjpeg-turbo-devel','libpng-devel','gettext-devel','zlib-devel','openssl-devel']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install PHP modules
packages = ['re2c']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
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
        it { should be_grouped_into 'root' }
        it { should be_mode 755 }
    end
end

# モジュールのテスト


