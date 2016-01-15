#
# Cookbook Name:: webapp_dev_env
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

data_ids = data_bag('users')
data_ids.each do |id|
	u = data_bag_item('users', id)
	user u['id'] do
		shell    u['shell']
		password u['password']
		supports :manage_home => true, :non_unique => false
		action   [:create]
	end

    # dev グループ作成
    group 'dev' do
        action :create
    end

	# dev グループへ追加/から削除
	if u['dev'] then
		group 'dev' do
			append true
			members u['id']
			action :modify
		end
	else
		group 'dev' do
			append true
			excluded_members u['id']
			action [:modify]
		end
	end
end


# Install Node.js & npm
yum_package ['nodejs', 'npm'] do
    action :install
    options "--enablerepo=epel"
end

# Install Bower
execute 'install_bower' do
	command 'npm install bower -g'
    not_if 'which bower'
end

# Install Gulp
execute 'install_gulp' do
	command 'npm install gulp -g'
    not_if 'which gulp'
end

# Install Composer
execute 'install_composer' do
    command 'curl -sS https://getcomposer.org/installer | php ;mv composer.phar /usr/local/bin/composer'
    not_if { ::File.exists?("/usr/local/bin/composer")}
end

# Install SASS
execute 'install_sass' do
	command 'gem install sass'
    not_if 'which sass'
end

