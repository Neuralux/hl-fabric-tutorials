Vagrant.configure("2") do |config|
  config.vm.box = "geerlingguy/centos7"
  config.vm.boot_timeout = 5400
  config.vm.provision "shell", privileged: true, path: "provision.sh"
end
