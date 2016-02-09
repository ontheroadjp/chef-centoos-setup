#
# Cookbook Name:: mysql56
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

#[mysqld]
## --------------------------------------------------
## Base
## --------------------------------------------------
#user = <%= node.set['mysql']['user'] %>
#port = <%= node.set['mysql']['port'] %>
#datadir = <%= node.set['mysql']['datadir'] %>
#socket  = <%= node.set['mysql']['socket'] %>
#pid-file = <%= node.set['mysql']['pid-file'] %>
#symbolic-links = <%= node.set['mysql']['symbolic-links'] %>
#sql_mode = <%= node.set['mysql']['sql_mode'] %>
#default-storage-engine = <%= node.set['mysql']['default-storage-engine'] %>
#transaction-isolation = <%= node.set['mysql']['transaction-isolation'] %>
#character-set-server = <%= node.set['mysql']['character-set-server'] %>
#collation-server = <%= node.set['mysql']['collation-server'] %>
#<% if node.set['mysql']['skip-character-set-client-handshake']['flag'] %>skip-character-set-client-handshake<% end %>
# 
## --------------------------------------------------
## Replication
## --------------------------------------------------
## not use Replication for now
#server-id    = <%= node.set['mysql']['server-id'] %>
#log-bin = <%= node.set['mysql']['log-bin'] %>
#
## --------------------------------------------------
## Network
## --------------------------------------------------
## Global
#<% if node.set['mysql']['skip-networking']['flag'] %>skip-networking<% end %>
#<% if node.set['mysql']['skip-name-resolve']['flag'] %>skip-name-resolve<% end %>
#max_connections = <%= node.set['mysql']['max_connections'] %>
#max_connect_errors = <%= node.set['mysql']['max_connect_errors'] %>
#connect_timeout = <%= node.set['mysql']['connect_timeout'] %>
#max_allowed_packet = <%= node.set['mysql']['max_allowed_packet'] %>
## Global, Session
#max_user_connections = <%= node.set['mysql']['max_user_connections'] %>
#wait_timeout = <%= node.set['mysql']['wait_timeout'] %>
#interactive_timeout = <%= node.set['mysql']['interactive_timeout'] %>
# 
## --------------------------------------------------
## Logging
## --------------------------------------------------
#log_output = <%= node.set['mysql']['log_output'] %>
#log_warnings = <%= node.set['mysql']['log_warnings'] %>
#general_log = <%= node.set['mysql']['general_log'] %>
#general_log_file = <%= node.set['mysql']['general_log_file'] %>
#log-slow-admin-statements = <%= node.set['mysql']['log-slow-admin-statements'] %>
#log-queries-not-using-indexes = <%= node.set['mysql']['log-queries-not-using-indexes'] %>
#slow_query_log = <%= node.set['mysql']['slow_query_log'] %>
#slow_query_log_file = <%= node.set['mysql']['slow_query_log_file'] %>
#long_query_time = <%= node.set['mysql']['long_query_time'] %>
#expire_logs_days = <%= node.set['mysql']['expire_logs_days'] %>
# 
## --------------------------------------------------
## Cache & Memory
## --------------------------------------------------
## Global
#thread_cache_size = <%= node.set['mysql']['thread_cache_size'] %>
#table_open_cache = <%= node.set['mysql']['table_open_cache'] %>
#query_cache_size = <%= node.set['mysql']['query_cache_size'] %>
#query_cache_limit = <%= node.set['mysql']['query_cache_limit'] %>
## Global, Session
#max_heap_table_size = <%= node.set['mysql']['max_heap_table_size'] %>
#tmp_table_size = <%= node.set['mysql']['tmp_table_size'] %>
#sort_buffer_size = <%= node.set['mysql']['sort_buffer_size'] %>
#read_buffer_size = <%= node.set['mysql']['read_buffer_size'] %>
#join_buffer_size = <%= node.set['mysql']['join_buffer_size'] %>
#read_rnd_buffer_size = <%= node.set['mysql']['read_rnd_buffer_size'] %>
# 
## --------------------------------------------------
## MyISAM
## --------------------------------------------------
## Global
#<% if node.set['mysql']['skip-external-locking']['flag'] %>skip-external-locking<% end %>
#key_buffer_size = <%= node.set['mysql']['key_buffer_size'] %>
#myisam_max_sort_file_size = <%= node.set['mysql']['myisam_max_sort_file_size'] %>
#myisam_recover_options = <%= node.set['mysql']['myisam_recover_options'] %>
## Global, Session
#bulk_insert_buffer_size = <%= node.set['mysql']['bulk_insert_buffer_size'] %>
#myisam_sort_buffer_size = <%= node.set['mysql']['myisam_sort_buffer_size'] %>
# 
## --------------------------------------------------------------------
## InnoDB behavior
## --------------------------------------------------------------------
## Global
#innodb_file_format = <%= node.set['mysql']['innodb_file_format'] %>
#innodb_write_io_threads = <%= node.set['mysql']['innodb_write_io_threads'] %>
#innodb_read_io_threads = <%= node.set['mysql']['innodb_read_io_threads'] %>
#innodb_stats_on_metadata = <%= node.set['mysql']['innodb_stats_on_metadata'] %>
#innodb_max_dirty_pages_pct = <%= node.set['mysql']['innodb_max_dirty_pages_pct'] %>
#innodb_adaptive_hash_index = <%= node.set['mysql']['innodb_adaptive_hash_index'] %>
#innodb_adaptive_flushing = <%= node.set['mysql']['innodb_adaptive_flushing'] %>
#innodb_strict_mode = <%= node.set['mysql']['innodb_strict_mode'] %>
#innodb_io_capacity = <%= node.set['mysql']['innodb_io_capacity'] %>
#innodb_autoinc_lock_mode = <%= node.set['mysql']['innodb_autoinc_lock_mode'] %>
#innodb_change_buffering = <%= node.set['mysql']['innodb_change_buffering'] %>
#innodb_old_blocks_time = <%= node.set['mysql']['innodb_old_blocks_time'] %>
# 
## --------------------------------------------------------------------
## InnoDB base
## --------------------------------------------------------------------
## Global
#innodb_buffer_pool_size = <%= node.set['mysql']['innodb_buffer_pool_size'] %>
#innodb_data_home_dir = <%= node.set['mysql']['innodb_data_home_dir'] %>
#innodb_data_file_path = <%= node.set['mysql']['innodb_data_file_path'] %>
#innodb_file_per_table = <%= node.set['mysql']['innodb_file_per_table'] %>
#innodb_autoextend_increment = <%= node.set['mysql']['innodb_autoextend_increment'] %>
#innodb_log_group_home_dir = <%= node.set['mysql']['innodb_log_group_home_dir'] %>
#innodb_fast_shutdown = <%= node.set['mysql']['innodb_fast_shutdown'] %>
#innodb_log_file_size = <%= node.set['mysql']['innodb_log_file_size'] %>
#innodb_log_files_in_group = <%= node.set['mysql']['innodb_log_files_in_group'] %>
#innodb_log_buffer_size = <%= node.set['mysql']['innodb_log_buffer_size'] %>
#innodb_additional_mem_pool_size = <%= node.set['mysql']['innodb_additional_mem_pool_size'] %>
#innodb_thread_concurrency = <%= node.set['mysql']['innodb_thread_concurrency'] %>
#innodb_flush_log_at_trx_commit = <%= node.set['mysql']['innodb_flush_log_at_trx_commit'] %>
#innodb_force_recovery = <%= node.set['mysql']['innodb_force_recovery'] %>
#innodb_doublewrite = <%= node.set['mysql']['innodb_doublewrite'] %>
#innodb_sync_spin_loops = <%= node.set['mysql']['innodb_sync_spin_loops'] %>
#innodb_thread_sleep_delay = <%= node.set['mysql']['innodb_thread_sleep_delay'] %>
#innodb_commit_concurrency = <%= node.set['mysql']['innodb_commit_concurrency'] %>
#innodb_concurrency_tickets = <%= node.set['mysql']['innodb_concurrency_tickets'] %>
## Global, Session
#innodb_support_xa = <%= node.set['mysql']['innodb_support_xa'] %>
#innodb_lock_wait_timeout = <%= node.set['mysql']['innodb_lock_wait_timeout'] %>
#innodb_table_locks = <%= node.set['mysql']['innodb_table_locks'] %>
# 
#[mysqldump]
#default-character-set = <%= node.set['mysql']['default-character-set'] %>
#<% if node.set['mysql']['quick']['flag'] %>quick<% end %>
#max_allowed_packet = <%= node.set['mysql']['max_allowed_packet'] %>
# 
#[mysql]
#default-character-set = <%= node.set['mysql']['default-character-set'] %>
#<% if node.set['mysql']['no-auto-rehash']['flag'] %>no-auto-rehash<% end %>
#<% if node.set['mysql']['show-warnings']['flag'] %>show-warnings<% end %>
# 
#[client]
#default-character-set = <%= node.set['mysql']['default-character-set'] %>
#port   = <%= node.set['mysql']['port'] %>
#socket = <%= node.set['mysql']['socket'] %>
# 
#[mysqld_safe]
#log-error = <%= node.set['mysql']['log-error'] %>

# install mysql community server
#package "mysql-community-server" do
#  action :remove
#end
package "mysql-community-server" do
  action :install
  version "5.6.29-2.el6"
  flush_cache [:before]
  options "--enablerepo=mysql56-community"
end

# Start MySQL
service "mysqld" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    only_if { ::File.exists?("/etc/rc.d/init.d/mysqld")}
    only_if {node['service']['mysqld']}
end

#--------------------------------------------------
# mysql_secure_installation 5.5
#--------------------------------------------------
# 1. Remove anonymous users? [Y/n] Y
# 2. Remove test database and access to it? [Y/n] Y
# 3. Disallow root login remotely? [Y/n] Y
# 4. Set root password? [Y/n] Y
# 5. Reload privilege tables now? [Y/n] Y
 
root_password = node['mysql']['root_password']
execute "mysql_secure_installation" do
    command <<-EOC
        mysql -u root -e "DELETE FROM mysql.user WHERE User='';"
        mysql -u root -e "DROP DATABASE test;"
        mysql -u root -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
        mysql -u root -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
        mysql -u root -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('#{root_password}');" -D mysql
        mysql -u root -p#{root_password} -e "SET PASSWORD FOR 'root'@'127.0.0.1' = PASSWORD('#{root_password}');" -D mysql
        mysql -u root -p#{root_password} -e "SET PASSWORD FOR 'root'@'::1' = PASSWORD('#{root_password}');" -D mysql
        mysql -u root -p#{root_password} -e "FLUSH PRIVILEGES;"
        EOC
    only_if "mysql -u root -e 'show databases'"
end

#template "/etc/my.cnf" do
#    source "my.cnf.erb"
#    owner "root"
#    group "root"
#    mode 0644
#end

## phpMyAdmin
#%w{phpMyAdmin}.each do |pkg|
#  package pkg do
#    # action [:install, :upgrade]
#    action :install
#    options "--enablerepo=remi --enablerepo=remi-php55"
#  end
#end
