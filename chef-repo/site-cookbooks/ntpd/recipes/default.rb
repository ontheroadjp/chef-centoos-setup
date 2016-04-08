#
# Cookbook Name:: ntpd
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


if platform_family?('rhel') && node['platform_version'].to_i == 6 then
    # install ntp
    package 'ntp' do
        action [:install, :upgrade]
    end
    template "/etc/ntp.conf" do
      source "ntp.conf.erb"
      owner "root"
      group "root"
      mode 0644
    end
    
    # start ntp
    service "ntpd" do
        action [:start, :enable]
        supports :status => true, :restart => true, :reload => true
        only_if {node['service']['ntp']}
    end

elsif platform_family?('rhel') && node['platform_version'].to_i == 7 then
    # use chronyd insted of ntpd for CentOS7
end
