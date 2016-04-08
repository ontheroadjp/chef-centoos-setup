require 'spec_helper'

## Create user:docker
#describe user('docker') do
#    it { should exist }
#    it { should belong_to_group 'docker' }
#end

# Create group:docker
describe group('docker') do
    it { should exist }
end

# Install Build tools
packages = ['docker']
packages.each do |pkg|
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install Docker Compose
describe file('/usr/local/bin/docker-compose') do
    it { should be_file }
end
describe command('docker-compose version') do
    #its(:stdout) { should match /docker-compose version 1\.5\.2, build 7240ff3/ }
    its(:stdout) { should match /docker-compose version 1\.6\.2, build 4d72027/ }
end

# Install Docker Compose
describe file('/etc/bash_completion.d/docker-compose') do
    it { should be_file }
end

