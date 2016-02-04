require 'serverspec'

# Install build tools
packages = [
    'autoconf','automake','libtool.x86_64','flex.x86_64','bison.x86_64','gcc.x86_64','make.x86_64','kernel-headers.x86_64','kernel-devel.x86_64','gcc-c++.x86_64','ccache' ]
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

