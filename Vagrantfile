VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

    #config.vm.box = "nrel/CentOS-6.7-x86_64"
    #config.vm.box_url = "https://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.7-x86_64-v20151108.box"
  
    config.vm.box = "CentOS-7.1-x86_64"
    config.vm.box_url = "https://github.com/holms/vagrant-centos7-box/releases/download/7.1.1503.001/CentOS-7.1.1503-x86_64-netboot.box"
  
    host = RbConfig::CONFIG['host_os']
    
    case host
        when /darwin/ # mac
            cpus = `sysctl -n hw.ncpu`.to_i
        when /linux/
            cpus = `nproc`.to_i
        else
            cpus = 2
    end
    
    config.vm.provider "virtualbox" do |vb|
        #vb.customize ["modifyvm", :id, "--cpus", cups]
        vb.customize ["modifyvm", :id, "--cpus", 3]
        vb.customize ["modifyvm", :id, "--memory", "2048"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        #vb.gui = true
    end

    # Provision
    provision_script = <<-EOH
        yum install -y git
        yum install -y vim-enhanced

        # Docker
        yum install -y docker-io
        groupadd docker
        gpasswd -a vagrant docker

        # Chef Development Kit & knife-solo
        wget https://opscode-omnibus-packages.s3.amazonaws.com/el/6/x86_64/chefdk-0.10.0-1.el6.x86_64.rpm
        rpm -ivh chefdk-0.10.0-1.el6.x86_64.rpm
        chef gem install knife-solo

        # bundller
        yum install -y ruby-devel
        gem install bundler
        export PATH=/home/vagrant/bin:$PATH
    EOH

    # VMs
    #config.vm.define :original do | original |
    #    original.vm.hostname = "vagrant-original"
    #    original.vm.network :forwarded_port, guest: 80, host: 8181
    #	original.vm.network :private_network, ip: "192.168.33.11"
    #    original.vm.provision :shell, :inline => provision_script
    #end
    config.vm.define :chef do | chef |
        chef.vm.hostname = "vagrang-chef"
        chef.vm.network :forwarded_port, guest: 80, host: 10080      # httpd
        chef.vm.network :forwarded_port, guest: 8080, host: 8080      # httpd
    	chef.vm.network :forwarded_port, guest: 3306, host: 3306    # mysqld
    	chef.vm.network :forwarded_port, guest: 8001, host: 8001    # jenkins
    	chef.vm.network :forwarded_port, guest: 10000, host: 10000  # webmin
    	chef.vm.network :forwarded_port, guest: 20000, host: 20000  # usermin
    	chef.vm.network :private_network, ip: "192.168.33.10"
    	chef.vm.synced_folder "html", "/usr/local/apache2/htdocs"
        #chef.vm.provision :shell, :inline => provision_script
    end
end
