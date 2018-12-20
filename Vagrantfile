Vagrant.configure("2") do |config|
  config.vm.define "kubernetes-master" do |master|
    master.vm.box = "centos/7"
    master.vm.network "public_network", ip: "192.168.1.120", bridge: "wlan0"
    master.vm.hostname  = "kubernetes-master"
    master.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
    master.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
    master.ssh.insert_key = false
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "kubernetes-master"
      vb.cpus = 2
    end
  end
  config.vm.define "kubernetes-worker1" do |worker1|
    worker1.vm.box = "centos/7"
    worker1.vm.network "public_network", ip: "192.168.1.121", bridge: "wlan0"
    worker1.vm.hostname = "kubernetes-worker1"
    worker1.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
    worker1.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
    worker1.ssh.insert_key = false
    worker1.vm.provider "virtualbox" do |vb|
      vb.memory = "2048"
      vb.name = "kubernetes-worker1"
      vb.cpus = 1
    end
  end
end




