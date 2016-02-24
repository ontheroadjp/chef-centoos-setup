require 'spec_helper'

# Create user:docker
describe user('docker') do
    it { should exist }
    it { should belong_to_group 'docker' }
end

# Create group:docker
describe group('docker') do
    it { should exist }
end

# Install Build tools
packages = ['docker-io']
packages.each do |pkg|
    describe package("#{pkg}") do
        it { should be_installed }
    end
end


