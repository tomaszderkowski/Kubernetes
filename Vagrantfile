ENV['VAGRANT_PARALLEL'] = 'yes'

bridge_adapter = "eth0"
box_image = "centos/7"
CPU = 2
MEMORY = 4096

VAGRANT_VM_PROVIDER   = "virtualbox"

Vagrant.configure("2") do |config|
    
  config.vm.define "kubernetes-master" do |master|
    master.vm.box = box_image
    master.vm.network "public_network", ip: "192.168.1.120", bridge: bridge_adapter
    master.vm.hostname  = "kubernetes-master"
    master.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
    master.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
    master.ssh.insert_key = false
    master.vm.provider "virtualbox" do |vb|
      vb.memory = MEMORY
      vb.name = "kubernetes-master"
      vb.cpus = CPU
    end
  end

  NodeCount = 2

  (1..NodeCount).each do |i|
    config.vm.define "kubernetes-worker#{i}" do |worker|
      worker.vm.box = box_image
      worker.vm.network "public_network", ip: "192.168.1.12#{i}", bridge: bridge_adapter
      worker.vm.hostname = "kubernetes-worker#{i}"
      worker.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
      worker.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
      worker.ssh.insert_key = false
      worker.vm.provider "virtualbox" do |vb|
        vb.memory = MEMORY
        vb.name = "kubernetes-worker#{i}"
        vb.cpus = CPU
      end
    end
  end

  config.vm.define "kubernetes-share" do |share|
    share.vm.box = box_image
    share.vm.network "public_network", ip: "192.168.1.12#{NodeCount + 1}", bridge: bridge_adapter
    share.vm.hostname  = "kubernetes-share"
    share.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
    share.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
    share.ssh.insert_key = false
    share.vm.provider "virtualbox" do |vb|
      vb.memory = 1024
      vb.name = "kubernetes-share"
      vb.cpus = 1
    end
  end
end