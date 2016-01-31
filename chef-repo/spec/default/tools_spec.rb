require 'spec_helper'

# git のインストール
# ctags のインストール
# gettext のインストール
# htop のインストール
#packages = [ 'git','ctags','gettext','htop' ]
#packages.each do | pkg |
#    describe package("#{pkg}") do
#        it { should be_installed }
#    end
#end

# vim(vim-enhanced) のインストール
packages = [ 'git','ctags','gettext','htop','vim' ]
packages.each do | pkg |
    if property['tools']["#{pkg}"]
        describe package("#{pkg}") do
            it { should be_installed }
        end
    end
end

# vim-lua のインストール
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

