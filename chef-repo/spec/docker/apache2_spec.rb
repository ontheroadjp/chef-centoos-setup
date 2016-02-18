require 'spec_helper'
require 'ohai'

ohai = Ohai::System.new
ohai.all_plugins

# Create user:apache
describe user('apache') do
    it { should exist }
    it { should have_login_shell '/bin/false' }
    it { should belong_to_group 'apache' }
end

# Create group:apache
describe group('apache') do
    it { should exist }
end

# Install Build tools
packages = ['wget','tar','gcc','gcc-c++','make','pcre','pcre-devel']
packages.each do |pkg|
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install ARP(Apache Portable Runtime): http://apr.apache.org/download.cgi
# Install ARP-util: http://apr.apache.org/download.cgi
describe file('/usr/local/src/apr-1.5.2.tar.gz') do
    its(:md5sum) { should eq '98492e965963f852ab29f9e61b2ad700' }
end

describe file('/usr/local/src/apr-util-1.5.4.tar.gz') do
    its(:md5sum) { should eq '866825c04da827c6e5f53daff5569f42' }
end

files = ['/opt/apr/apr-1.5.2/lib/libapr-1.so.0.5.2','/opt/apr/apr-util-1.5.4/lib/libexpat.so.0.5.0']
files.each do | file |
    describe file("#{file}") do
        it { should be_file }
    end
end


# Install Apache: http://apr.apache.org/download.cgi
# Change directory group and owner
describe file('/usr/local/src/httpd-2.4.18.tar.gz') do
    its(:md5sum) { should eq '2f90ce3426541817e0dfd01cae086b60' }
end
describe file("/usr/local/apache2/bin/httpd") do
    it { should be_file }
    it { should be_owned_by 'apache'}
    it { should be_grouped_into 'apache'}
end  
# モジュールのテスト
describe command('ldd /usr/local/apache2/modules/mod_ssl.so | grep libssl.so') do
    its(:stdout) { should match /libssl\.so\.10 => \/usr\/lib64\/libssl\.so\.10/ }
end
describe command('ldd /usr/local/apache2/modules/mod_ssl.so | grep libcrypt.so') do
    its(:stdout) { should match /libcrypt\.so\.1 => \/lib64\/libcrypt\.so\.1/ }
end
describe command('ldd /usr/local/apache2/bin/httpd | grep pcre') do
    its(:stdout) { should match /libpcre\.so\.0 => \/lib64\/libpcre\.so\.0/ }
end
describe command('ldd /usr/local/apache2/bin/httpd | grep crypt') do
    its(:stdout) { should match /libcrypt\.so\.1 => \/lib64\/libcrypt\.so\.1/ }
end

#Replace httpd.conf
describe file('/usr/local/apache2/conf/httpd.conf') do
    it { should be_file }
    it { should contain 'DocumentRoot "/usr/local/apache2/htdocs"' }
    it { should contain '<Directory "/usr/local/apache2/htdocs">' }
    it { should be_owned_by 'apache' }
    it { should be_grouped_into 'apache' }
    it { should be_mode '644' }
end

# Add service script
if ohai[:platform_family] == 'rhel' && ohai[:platform_version].to_i == 6 then
    describe file('/etc/rc.d/init.d/httpd') do
        it { should be_file }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'root' }
        it { should be_mode '755' }
    end
    describe command('chkconfig --list httpd') do
        its(:stdout) { should match /0:off/ }
        its(:stdout) { should match /1:off/ }
        its(:stdout) { should match /2:on/ }
        its(:stdout) { should match /3:on/ }
        its(:stdout) { should match /4:on/ }
        its(:stdout) { should match /5:on/ }
        its(:stdout) { should match /6:off/ }
    end
end

# Regist service
describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
end

describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
end


