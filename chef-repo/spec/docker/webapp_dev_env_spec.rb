require 'serverspec'

packages = ['which']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install Node.js
# Install npm
packages = ['nodejs','npm']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Install Bower
# Install Gulp
packages = ['bower','gulp']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed.by('npm') }
    end
end

# Install Composer
describe file('/usr/local/bin/composer') do
    it { should be_file }
end

#describe command('composer --version') do
#    its(:stdout) { should match /Composer\ version\ 1/ }
#end

# Install SASS
describe package('sass') do
    it { should be_installed.by('gem') }
end

