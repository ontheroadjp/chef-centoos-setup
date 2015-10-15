#
# Cookbook Name:: centos
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# epel
bash 'add_epel' do
  user 'root'
  code <<-EOC
    rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/epel.repo
  EOC
  creates "/etc/yum.repos.d/epel.repo"
end

# rpmforge
bash 'add_rpmforge' do
  user 'root'
  code <<-EOC
    rpm -ivh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/rpmforge.repo
  EOC
  creates "/etc/yum.repos.d/rpmforge.repo"
end

# remi
bash 'add_remi' do
  user 'root'
  code <<-EOC
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
    sed -i -e "s/enabled *= *1/enabled=0/g" /etc/yum.repos.d/remi.repo
  EOC
  creates "/etc/yum.repos.d/remi.repo"
end


=begin
php-devel : phpを拡張するために必要
php-mbstring : php 日本語環境に関する設定
php-mcrypt : WEB通信に暗号化モジュール
=end

%w{libmcrypt}.each do |pkg|
  package pkg do
    action :install
    options "--enablerepo=epel"
  end
end

%w{httpd mysql-server php php-devel php-mbstring php-mysql php-xml php-mcrypt vim-enhanced git}.each do |pkg|
  package pkg do
    # action [:install, :upgrade]
    action :install
    options "--enablerepo=remi --enablerepo=remi-php55"
  end
end

execute "install_composer" do
  command "curl -sS https://getcomposer.org/installer | php ;mv composer.phar /usr/local/bin/composer"
  not_if { ::File.exists?("/usr/local/bin/composer")}
end

execute "install_laravel" do
  command "composer create-project laravel/laravel laravel --prefer-dist"
  # creates "/var/www/laravel"
  action :run
end

execute "move_laravel" do
  command "mv laravel/ /var/www/html/laravel"
  # creates "/var/www/html/laravel"
  action :run
end

=begin
link "/var/www/html/public" do
  to "/var/www/laravel/public"
  link_type :symbolic
end
=end

execute "chmod_laravel_public" do
  command "chmod -R 777 /var/www/html/laravel/storage"
  action :run
  only_if { ::File.exists?("/var/www/html/laravel/storage")}

end

service "iptables" do
  action [:stop, :disable]
end

service "httpd" do
  action [:start, :enable]
  supports :status => true, :restart => true
end


