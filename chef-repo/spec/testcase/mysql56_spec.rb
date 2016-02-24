require 'spec_helper'

describe package('mysql-community-server') do
    it { should be_installed }
end

describe command('chkconfig --list mysqld') do
    its(:stdout) { should match /0:off/ }
    its(:stdout) { should match /1:off/ }
    its(:stdout) { should match /2:on/ }
    its(:stdout) { should match /3:on/ }
    its(:stdout) { should match /4:on/ }
    its(:stdout) { should match /5:on/ }
    its(:stdout) { should match /6:off/ }
end

