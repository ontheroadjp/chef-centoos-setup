#
# Cookbook Name:: laravel51
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# Composer
execute "install_composer" do
  command "curl -sS https://getcomposer.org/installer | php ;mv composer.phar /usr/local/bin/composer"
  not_if { ::File.exists?("/usr/local/bin/composer")}
end

# Laravel
execute "install_laravel" do
  command "composer create-project laravel/laravel laravel --prefer-dist"
  # creates "/var/www/laravel"
  action :run
  not_if { ::File.exists?("/var/www/laravel")}
end

execute "move_laravel" do
  command "mv laravel/ /var/www/laravel"
  creates "/var/www/laravel"
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

