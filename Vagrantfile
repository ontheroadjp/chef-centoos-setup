# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure(2) do |config|

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.

  config.vm.box = "nrel/CentOS-6.5-x86_64"
  config.vm.hostname = "centos"

	config.vm.network :private_network, ip: "192.168.33.10"
	config.vm.network :forwarded_port, guest: 80, host: 8080
	config.vm.synced_folder "www", "/var/www"

#	config.omnibus.chef_version = :latest
#	config.berkshelf.enabled = true

end
