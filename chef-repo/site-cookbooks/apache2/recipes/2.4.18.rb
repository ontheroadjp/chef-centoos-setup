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
        ./buildconf --force
        make clean
        ./configure \
        --prefix=/opt/apr/apr-1.5.2 \
        2>&1 | tee log_configure.txt
        EOH
    action :run
end
execute "APR make" do
    cwd "/usr/local/src/apr-1.5.2"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"
    )
    command "make -j8 2>&1 | tee log_make.txt"
    action :run
end
execute "APR make install" do
    cwd "/usr/local/src/apr-1.5.2"
    user "root"
    command "make install 2>&1 | tee log_make_install.txt"
    action :run
end


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
        ./buildconf --force
        make clean
        ./configure \
        --prefix=/opt/apr/apr-util-1.5.4 \
        --with-apr=/opt/apr/apr-1.5.2 \
        2>&1 | tee log_configure.txt
        EOH
    action :run
end
execute "APR-util make" do
    cwd "/usr/local/src/apr-util-1.5.4"
    user "root"
    environment(
        "USE_CCACHE" => "1",
        "CCACHE_DIR" => "/root/.ccache",
        "CC" => "ccache gcc",
        "CXX" => "ccache g++"
    )
    command "make -j8 2>&1 | tee log_make.txt"
    action :run
end
execute "APR-util make install" do
    cwd "/usr/local/src/apr-util-1.5.4"
    user "root"
    command "make install 2>&1 | tee log_make_install.txt"
    action :run
end

# -------------------------------------
# Install Apache: http://apr.apache.org/download.cgi
# -------------------------------------
#packages = ['httpd-devel','pcre','pcre-devel','libmcrypt','libmcrypt-devel','gettext','gettext-devel']
packages = ['pcre','pcre-devel','libmcrypt','libmcrypt-devel','gettext','gettext-devel']
packages.each do | pkg |
    package pkg do
        action [:install, :upgrade]
        options "--enablerepo=epel"
    end
end
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
execute "httpd(apache2) - ./configure" do
    cwd "/usr/local/src/httpd-2.4.18"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command <<-EOH
        ./buildconf --force
        make clean
        ./configure \
        --prefix=/usr/local/apache2 \
        --with-mpm=worker \
        --with-apr=/opt/apr/apr-1.5.2 \
        --with-apr-util=/opt/apr/apr-util-1.5.4 \
        --enable-ssl \
        --with-ssl \
        --with-pcre \
        --with-mcrypt \
        --with-gettext \
        2>&1 | tee log_configure.txt
        EOH
    action :run
end
execute "httpd(apache2) make" do
    cwd "/usr/local/src/httpd-2.4.18"
    user "root"
    #environment(
    #    "USE_CCACHE" => "1",
    #    "CCACHE_DIR" => "/root/.ccache",
    #    "CC" => "ccache gcc",
    #    "CXX" => "ccache g++"
    #)
    command "make -j8 2>&1 | tee log_make.txt"
    action :run
end
execute "httpd(apache2) make install" do
    cwd "/usr/local/src/httpd-2.4.18"
    user "root"
    command "make install 2>&1 | tee log_make_install.txt"
    action :run
end

# Change directory group and owner
directory "/usr/local/apache2" do
    owner       'apache'
    group       'apache'
    recursive   true   
    only_if { ::File.exists?("/usr/local/apache2/bin/httpd")}
end

# Replace httpd.conf
template "/usr/local/apache2/conf/httpd.conf" do
  source "2.4.18/httpd.conf.erb"
  owner "apache"
  group "apache"
  mode 0644
end

# Regist service
if platform_family?('rhel') && node['platform_version'].to_i == 6 then
    template "/etc/rc.d/init.d/httpd" do
      source "2.4.18/httpd.init.erb"
      owner "root"
      group "root"
      mode 0755
    end
end

# Start apache
service "httpd" do
    action [:start, :enable]
    supports :status => true, :restart => true, :reload => true
    #only_if { ::File.exists?("/etc/rc.d/init.d/httpd")}
    only_if {node['service']['httpd']}
end

#if platform_family?('rhel') && node['platform_version'].to_i == 6 then
#    execute "regist service" do
#        user "root"
#        command "chkconfig --add httpd"
#        action :run
#    end
#elsif platform_family?('rhel') && node['platform_version'].to_i == 7 then
#    execute "regist service" do
#        user "root"
#        command "systemctl enable httpd.service"
#        action :run
#    end
#end

