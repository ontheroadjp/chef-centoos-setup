require 'spec_helper'

#packages = [ 'git','ctags','gettext','htop' ]
#packages.each do | pkg |
#    describe package("#{pkg}") do
#        it { should be_installed }
#    end
#end

# Install vim(vim-enhanced)
packages = [ 'git','ctags','gettext','htop','vim' ]
packages.each do | pkg |
    if property['tools']["#{pkg}"]
        describe package("#{pkg}") do
            it { should be_installed }
        end
    end
end

# Install vim-lua
if property['tools']['vim-lua']
    packages = [ 'mercurial','ncurses-devel','lua','lua-devel' ]
    packages.each do | pkg |
        describe package("#{pkg}") do
            it { should be_installed }
        end
    end
end

describe file('/usr/local/bin/vim') do
    it { should be_file }
    it { should be_owned_by 'root' }
end

