require 'spec_helper'

# Install Java
packages = ['java-1.7.0-openjdk','java-1.7.0-openjdk-devel']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Add Repository
describe file('/etc/yum.repos.d/jenkins.repo') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '644' }
end

# Install Jenkins
describe package('jenkins') do
    it { should be_installed }
end
describe user('jenkins') do
    it { should exist }
    it { should have_login_shell '/bin/false' }
    it { should belong_to_group 'wheel' }
end
describe file('/etc/sysconfig/jenkins') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode '600' }
    its(:contain) { "JENKINS_JAVA_OPTIONS=\"-Djava.awt.headless=true -Dhudson.util.ProcessTree.disable =true -Dorg.apache.commons.jelly.tags.fmt.timeZone=Asia/Tokyo" }
    its(:contain) { "JENKINS_PORT=property['jenkins']['port']" }
    its(:contain) { "JENKINS_ARGS=\"--prefix=property['jenkins']['prefix']" }
end

# Start Jenkins
describe command('chkconfig --list jenkins') do
    its(:stdout) { should match /0:off/ }
    its(:stdout) { should match /1:off/ }
    its(:stdout) { should match /2:off/ }
    its(:stdout) { should match /3:on/ }
    its(:stdout) { should match /4:off/ }
    its(:stdout) { should match /5:on/ }
    its(:stdout) { should match /6:off/ }
end

# Regist service
describe service('jenkins'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
end

