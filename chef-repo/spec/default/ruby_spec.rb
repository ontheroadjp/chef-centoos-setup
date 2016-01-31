require 'serverspec'

# package install needed
packages = [ 'git','openssl-devel','readline-devel','zlib-devel','libcurl-devel' ]
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Create rbenv group
describe group( 'rbenv' ) do
    it { should exist }
end

# Install rbenv
describe file('/usr/local/rbenv/.git') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'rbenv' }
    it { should be_mode 755 }
end
dirs = ['/usr/local/rbenv/shims','/usr/local/rbenv/versions','/usr/local/rbenv/plugins']
dirs.each do | dir |
    describe file("#{dir}") do
        it { should be_directory }
        it { should be_owned_by 'root' }
        it { should be_grouped_into 'rbenv' }
        it { should be_mode 755 }
    end
end

# Install ruby-build
describe file('/usr/local/rbenv/plugins/ruby-build/.git') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'rbenv' }
    it { should be_mode 755 }
end

# Install rbenv-default-gems
describe file('/usr/local/rbenv/plugins/ruby-default-gems/.git') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'rbenv' }
    it { should be_mode 755 }
    #it { should be_readable.by('group') }
    #it { should be_writable.by('group') }
    #it { should be_executable.by('group') }
end

# Set Environment variables
describe file('/etc/profile.d/rbenv.sh') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match(/^export RBENV_ROOT="\/usr\/local\/rbenv"$/) }
    its(:content) { should match(/^export PATH="\$RBENV_ROOT\/bin:\$PATH"$/) }
    its(:content) { should match(/^eval "\$\(rbenv init -\)"$/) }
end

# Set default-gems
describe file('/usr/local/rbenv/default-gems') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 644 }
    its(:content) { should match(/^bundler$/) }
    its(:content) { should match(/^rpy$/) }
    its(:content) { should match(/^rbenv-rehash$/) }
end

# Install Ruby
describe command("source /etc/profile.d/rbenv.sh; rbenv versions | grep 2.3.0" ) do
    let(:disable_sudo) { true }
    its(:stdout) { should match(/#{Regexp.escape('2.3.0')}/) }
end

# Use ruby installed
describe command("source /etc/profile.d/rbenv.sh; rbenv global" ) do
    let(:disable_sudo) { true }
    it { should return_stdout('2.3.0') }
end


