ENV['VAGRANT_PARALLEL'] = 'yes'

bridge_adapter = "wlan0"
box_image = "centos/7"

Vagrant.configure("2") do |config|
  config.vm.define "kubernetes-master" do |master|
    master.vm.box = box_image
    master.vm.network "public_network", ip: "192.168.1.120", bridge: bridge_adapter
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

  NodeCount = 1

  (1..NodeCount).each do |i|
    config.vm.define "kubernetes-worker#{i}" do |worker|
      worker.vm.box = box_image
      worker.vm.network "public_network", ip: "192.168.1.12#{i}", bridge: bridge_adapter
      worker.vm.hostname = "kubernetes-worker#{i}"
      worker.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "~/.ssh/authorized_keys"
      worker.ssh.private_key_path = ["~/.ssh/id_rsa", "~/.vagrant.d/insecure_private_key"]
      worker.ssh.insert_key = false
      worker.vm.provider "virtualbox" do |vb|
        vb.memory = "2048"
        vb.name = "kubernetes-worker#{i}"
        vb.cpus = 1
      end
    end
  end
end