# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
    config.vm.box = "precise32"
    config.vm.box_url = "http://files.vagrantup.com/precise32.box"

    config.vm.network :forwarded_port, guest: 5050, host: 8160 # Socket.io (node)
    config.vm.network :forwarded_port, guest: 80, host: 8050   # Nginx
    config.vm.network :forwarded_port, guest: 6379, host: 6379 # Redis
    config.vm.network :forwarded_port, guest: 1618, host: 8060 # Django (runserver)
    config.vm.network :forwarded_port, guest: 4000, host: 8070 # Phpgadmin

    config.vm.hostname = "wonderland"
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", 1024]
    end

    config.vm.provision :chef_solo do |chef|
        chef.cookbooks_path = "kitchen/cookbooks"
        chef.roles_path = "kitchen/roles"
        chef.json  = {
        }
        chef.add_role "vagrant"
    end
end
