require 'serverspec'

# Install build tools
packages = ['wget','tar','gcc','gcc-c++','make','ccache','pcre','pcre-devel']
packages.each do | pkg |
    describe package("#{pkg}") do
        it { should be_installed }
    end
end

# Make directory for ccache
describe file('/root/.ccache') do
    it { should be_directory }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    it { should be_mode 755 }
end



