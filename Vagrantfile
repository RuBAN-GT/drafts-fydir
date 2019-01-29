Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = 'fydir'

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", "4096"]
    vb.customize ["guestproperty", "set", :id, "--timesync-threshold", 5000]
  end

  config.ssh.username = "vagrant"
  config.ssh.password = "vagrant"

  config.vm.network :private_network, type: "dhcp"
  config.vm.synced_folder ".", "/home/vagrant/FYDIR"

  config.vm.network :forwarded_port, guest: 3000, host: 3000, auto_correct: true
  config.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: true
  config.vm.network :forwarded_port, guest: 22, host: 2221, auto_correct: true

  config.vm.provision "shell", path: "provision.sh"
end
