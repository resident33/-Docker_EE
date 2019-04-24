hosts = [
    { name: 'vm-jenkinsmaster',   box: 'ubuntu/xenial64',	        mem: 2048,	netint: 1 },
    { name: 'vm-swarmmaster',     box: 'ubuntu/xenial64',		mem: 2048,	netint: 2 },
    { name: 'vm-swarmslave1',     box: 'ubuntu/xenial64',		mem: 2048,	netint: 3 }
]




$message = <<MESSAGE
------------------------------------------------------
Host server , accessible at 127.0.0.1
URLS:
 - jenkins  - http://localhost:8080/

------------------------------------------------------
MESSAGE



Vagrant.configure('2') do |config|
  hosts.each do |host|
    config.vm.define host[:name] do |node|
      node.vm.box = host[:box]
      node.vm.hostname = host[:name]
      node.vm.provider :virtualbox do |vm|
        vm.memory = host[:mem]
      end

      if host[:netint] == 1
        node.vm.network :public_network, bridge: 'enp6s0'
        node.vm.provision 'shell', path: 'jenkins_install.sh'
	config.vm.post_up_message = $message
      end

      if host[:netint] == 2
        node.vm.network :public_network, bridge: 'enp6s0'
        node.vm.provision 'shell', path: 'skript.sh'
      end
     if host[:netint] == 3
        node.vm.network :public_network, bridge: 'enp6s0'
        node.vm.provision 'shell', path: 'skript.sh'
      end


    end
    config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
    Vagrant::Config.run do |config|
      config.vbguest.auto_update = false
      config.vbguest.no_remote = true
    end
  end
end

