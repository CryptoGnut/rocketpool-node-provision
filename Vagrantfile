Vagrant.configure("2") do |config|

    config.vm.provider "virtualbox" do |v|
      v.memory = 16384
      v.cpus = 8
    end
    
    config.vm.define "rocketpool-miner"
    config.vm.hostname = "vagrant-rp1"
    config.vm.box = "generic/ubuntu2004"
    config.vm.network "forwarded_port", guest: 30303, host: 30303, protocol: "tcp", id: "eth1 (tcp)"
    config.vm.network "forwarded_port", guest: 30303, host: 30303, protocol: "udp", id: "eth1 (udp)"
    config.vm.network "forwarded_port", guest: 9001, host: 9001, protocol: "tcp", id: "eth2 (tcp)"
    config.vm.network "forwarded_port", guest: 9001, host: 9001, protocol: "udp", id: "eth2 (udp)"
    config.vm.network "forwarded_port", guest: 3100, host: 3100, protocol: "tcp", id: "grafana"
    
    config.vm.synced_folder '.', '/vagrant', disabled: true
    
    config.vm.provision "shell", inline: <<-SHELL
      adduser dan --disabled-password --gecos ""
      echo "dan ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/dan
      sudo -u dan mkdir -m700 /home/dan/.ssh
      sudo -u dan echo \"#{ENV['PUBLIC_SSH_KEY']}\" > /home/dan/.ssh/authorized_keys
      chown dan:dan /home/dan/.ssh/authorized_keys
      sudo -u dan chmod 600 /home/dan/.ssh/authorized_keys
    SHELL
  end