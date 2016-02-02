#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2015, @ontheroad_jp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "build_tools"

user "apache" do
    shell    '/bin/false'
    system  true
    action  :create
end
group "apache" do
    append true
    members 'apache'
    action :modify
end

# -------------------------------------
# Install ARP(Apache Portable Runtime): http://apr.apache.org/download.cgi
# -------------------------------------
remote_file "/usr/local/src/apr-1.5.2.tar.gz" do
    source 'http://ftp.yz.yamagata-u.ac.jp/pub/network/apache//apr/apr-1.5.2.tar.gz'
    action :create
    not_if { ::File.exists?("/usr/local/src/apr-1.5.2.tar.gz")}
end
execute "APR - Untarball" do
    cwd "/usr/local/src"
    user "root"
    command "tar -xvzf apr-1.5.2.tar.gz"
    action :run
    only_if { ::File.exists?("/usr/local/src/apr-1.5.2.tar.gz")}
    not_if { ::File.exists?("/usr/local/src/apr-1.5.2")}
end
execute "APR - Build.." do
    cwd "/usr/local/src/apr-1.5.2"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"

    )
    command <<-EOH
        ./configure --prefix=/opt/apr/apr-1.5.2
        make -j 4
        make -j 4 install
        EOH
    action :run
end
#execute "APR make" do
#    cwd "/usr/local/src/apr-1.5.2"
#    user "root"
#    environment(
#        "USE_CCACHE" => "1",
#        "CCACHE_DIR" => "/root/.ccache",
#        "CC" => "ccache gcc",
#        "CXX" => "ccache g++"
#    )
#    command "make -j 4"
#    action :run
#end
#execute "APR make install" do
#    cwd "/usr/local/src/apr-1.5.2"
#    user "root"
#    command "make -j 4 install"
#    action :run
#end


# -------------------------------------
# Install ARP-util: http://apr.apache.org/download.cgi
# -------------------------------------
remote_file "/usr/local/src/apr-util-1.5.4.tar.gz" do
    source 'http://ftp.yz.yamagata-u.ac.jp/pub/network/apache//apr/apr-util-1.5.4.tar.gz'
    action :create
    not_if { ::File.exists?("/usr/local/src/apr-util-1.5.4.tar.gz")}
end
execute "APR-util - Untarball" do
    cwd "/usr/local/src"
    user "root"
    command "tar -xvzf apr-util-1.5.4.tar.gz"
    action :run
    only_if { ::File.exists?("/usr/local/src/apr-util-1.5.4.tar.gz")}
    not_if { ::File.exists?("/usr/local/src/apr-util-1.5.4")}
end
execute "APR-util - Build.." do
    cwd "/usr/local/src/apr-util-1.5.4"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"
    )
    command <<-EOH
        ./configure --prefix=/opt/apr/apr-util-1.5.4 --with-apr=/opt/apr/apr-1.5.2
        make -j 4
        make -j 4 install
        EOH
    action :run
end
#execute "APR-util make" do
#    cwd "/usr/local/src/apr-util-1.5.4"
#    user "root"
#    environment(
#        "USE_CCACHE" => "1",
#        "CCACHE_DIR" => "/root/.ccache",
#        "CC" => "ccache gcc",
#        "CXX" => "ccache g++"
#    )
#    command "make -j 4"
#    action :run
#end
#execute "APR-util make install" do
#    cwd "/usr/local/src/apr-util-1.5.4"
#    user "root"
#    command "make -j 4 install"
#    action :run
#end

# -------------------------------------
# Install Apache: http://apr.apache.org/download.cgi
# -------------------------------------
remote_file "/usr/local/src/httpd-2.4.18.tar.gz" do
    source 'http://ftp.jaist.ac.jp/pub/apache//httpd/httpd-2.4.18.tar.gz'
    action :create
    not_if { ::File.exists?("/usr/local/src/httpd-2.4.18.tar.gz")}
end
execute "httpd(Apache2) - Untarball" do
    cwd "/usr/local/src"
    user "root"
    command "tar -xvzf httpd-2.4.18.tar.gz"
    action :run
    only_if { ::File.exists?("/usr/local/src/httpd-2.4.18.tar.gz")}
    not_if { ::File.exists?("/usr/local/src/httpd-2.4.18")}
end
execute "httpd(apache2) - Build.." do
    cwd "/usr/local/src/httpd-2.4.18"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"
    )
    command <<-EOH
        ./configure \
        --prefix=/usr/local/apache2 \
        --with-apr=/opt/apr/apr-1.5.2 \
        --with-apr-util=/opt/apr/apr-util-1.5.4
        make -j 4
        make -j 4 install
        EOH
    action :run
end
#execute "httpd(apache2) make" do
#    cwd "/usr/local/src/httpd-2.4.18"
#    user "root"
#    environment(
#        "USE_CCACHE" => "1",
#        "CCACHE_DIR" => "/root/.ccache",
#        "CC" => "ccache gcc",
#        "CXX" => "ccache g++"
#    )
#    command "make -j 4"
#    action :run
#end
#execute "httpd(apache2) make install" do
#    cwd "/usr/local/src/httpd-2.4.18"
#    user "root"
#    command "make -j 4 install"
#    action :run
#end

# Change directory group and owner
directory "/usr/local/apache2" do
    group       'apache'
    owner       'apache'
    recursive   true   
    only_if { ::File.exists?("/usr/local/apache2")}
end

# Replace httpd.conf
template "/usr/local/apache2/conf/httpd.conf" do
  source "2.4.18/httpd.conf.erb"
  owner "apache"
  group "apache"
  mode 0644
end

# Add service script
template "/etc/rc.d/init.d/httpd" do
  source "2.4.18/httpd.init.erb"
  owner "root"
  group "root"
  mode 0755
end

# Regist service
execute "regist service" do
    user "root"
    command "chkconfig --add httpd"
    action :run
end

