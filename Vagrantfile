# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Web Server (will host the application)
  config.vm.define "web-server" do |web|
    web.vm.box = "bento/ubuntu-22.04"
    web.vm.hostname = "web-server"
    web.vm.network "private_network", ip: "192.168.56.10"
    
    web.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 1
      vb.name = "web-server"
    end
    
    # Enable SSH agent forwarding
    web.ssh.forward_agent = true
  end

  # Management Server (Ansible control node)
  config.vm.define "mgmt-server" do |mgmt|
    mgmt.vm.box = "bento/ubuntu-22.04"
    mgmt.vm.hostname = "mgmt-server"
    mgmt.vm.network "private_network", ip: "192.168.56.11"
    
    mgmt.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.cpus = 1
      vb.name = "mgmt-server"
    end
    
    # Provision Ansible on the management server
    mgmt.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y ansible sshpass
      echo "[web]" > /home/vagrant/inventory.ini
      echo "192.168.56.10 ansible_ssh_user=vagrant ansible_ssh_pass=vagrant" >> /home/vagrant/inventory.ini
      echo -e "\n[all:vars]" >> /home/vagrant/inventory.ini
      echo "ansible_python_interpreter=/usr/bin/python3" >> /home/vagrant/inventory.ini
    SHELL
  end
  
  # Enable file sharing from project directory to both VMs
  config.vm.synced_folder ".", "/vagrant", disabled: false
end
