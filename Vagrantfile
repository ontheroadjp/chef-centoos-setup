
Vagrant.configure(2) do |config|

  config.vm.box = "nrel/CentOS-6.7-x86_64"
  #config.vm.box_url = "https://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.7-x86_64-v20151108.box"
  
  # config.vm.box = "bento/centos-6.7"
  config.vm.hostname = "centos"

    config.vm.network :forwarded_port, guest: 80, host: 8080
	config.vm.network :forwarded_port, guest: 3306, host: 3306
	config.vm.network :private_network, ip: "192.168.33.10"
	config.vm.synced_folder "html", "/usr/local/apache2/htdocs"

#	config.omnibus.chef_version = :latest
#	config.berkshelf.enabled = false

    host = RbConfig::CONFIG['host_os']
    
    case host
    when /darwin/ # mac
        cpus = `sysctl -n hw.ncpu`.to_i
    when /linux/
        cpus = `nproc`.to_i
    else
        cpus = 2
    end
    
    # for VirtualBox
    config.vm.provider "virtualbox" do |vb|
        #vb.cpus = cpus / 2
        #vb.memory = 1024
        #vb.customize ["modifyvm", :id, "--cpus", cups]
        vb.customize ["modifyvm", :id, "--cpus", 2]
        vb.customize ["modifyvm", :id, "--memory", "8192"]
        vb.customize ["modifyvm", :id, "--natdnsproxy1", "off"]
        vb.customize ["modifyvm", :id, "--natdnshostresolver1", "off"]
    end

    # for VMware Fusion
    #config.vm.provider "vmware_fusion" do |v|
    #    v.vmx["numvcpus"] = cpus
    #end

end
