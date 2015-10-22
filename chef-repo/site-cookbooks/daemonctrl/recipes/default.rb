#
# Cookbook Name:: sakuravps_tuning
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

execute "stop_daemon" do
	command <<-EOH
		chkconfig auditd off > /dev/null 2>&1
		chkconfig autofs off > /dev/null 2>&1
		chkconfig avahi-daemon off > /dev/null 2>&1
		chkconfig bluetooth off > /dev/null 2>&1
		chkconfig cups off > /dev/null 2>&1
		chkconfig firstboot off > /dev/null 2>&1
		chkconfig gpm off > /dev/null 2>&1
		chkconfig haldaemon off > /dev/null 2>&1
		chkconfig hidd off > /dev/null 2>&1
		chkconfig isdn off > /dev/null 2>&1
		chkconfig kudzu off > /dev/null 2>&1
		chkconfig lvm2-monitor off > /dev/null 2>&1
		chkconfig mcstrans off > /dev/null 2>&1
		chkconfig mdmonitor off > /dev/null 2>&1
		chkconfig messagebus off > /dev/null 2>&1
		chkconfig netfs off > /dev/null 2>&1
		chkconfig nfslock off > /dev/null 2>&1
		chkconfig pcscd off > /dev/null 2>&1
		chkconfig portmap off > /dev/null 2>&1
		chkconfig rawdevices off > /dev/null 2>&1
		chkconfig restorecond off > /dev/null 2>&1
		chkconfig rpcgssd off > /dev/null 2>&1
		chkconfig rpcidmapd off > /dev/null 2>&1
		chkconfig smartd off > /dev/null 2>&1
		chkconfig xfs off > /dev/null 2>&1
		chkconfig yum-updatesd off > /dev/null 2>&1
	EOH
	action :run
end
