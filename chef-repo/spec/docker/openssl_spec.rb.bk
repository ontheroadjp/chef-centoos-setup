require 'spec_helper'

# Install dipendence modules
packages = ['libmcrypt','libmcrypt-devel','zlib-devel','openssl-devel']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install OpenSSL
describe 'Installing Open SSL' do
    describe file('/usr/local/src/openssl-1.0.2f.tar.gz') do
        it { should be_file }
        its(:sha256sum) { should eq '932b4ee4def2b434f85435d9e3e19ca8ba99ce9a065a61524b429a9d5e9b2e9c' }
    end
    describe file('/usr/local/openssl/bin/openssl') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 755 }
    end
    describe file('/etc/ld.so.conf.d/openssl.conf') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode 644 }
        its(:content) { should match(/^\/usr\/local\/openssl\/lib$/) }
    end
    describe command("ldconfig -p | grep openssl | grep libssl.so.1.0.0") do
        its(:stdout) { should match /libssl\.so\.1\.0\.0 \(libc6,x86-64\) => \/usr\/local\/openssl\/lib\/libssl\.so\.1\.0\.0$/ }
    end
end

