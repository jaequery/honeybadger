Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
    v.cpus = 1
    v.linked_clone = true
  end
  config.vm.provision :docker
  config.vm.provision :docker_compose
  config.vm.network :private_network, ip: "192.168.99.100"
  #config.vm.provision "shell",
  # inline: "/bin/sh /vagrant/bin/container_init.sh"
end
