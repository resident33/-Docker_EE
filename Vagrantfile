hosts = [
    { name: 'vm-jenkinsmaster',   box: 'ubuntu/xenial64',	        mem: 2048,	netint: 1 },
    { name: 'vm-swarmmaster',     box: 'ubuntu/xenial64',		mem: 4192,	netint: 2 },
    { name: 'vm-swarmslave1',     box: 'ubuntu/xenial64',		mem: 2048,	netint: 3 }
]




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
      end

      if host[:netint] == 2
        node.vm.network :public_network, bridge: 'enp6s0'
        node.vm.provision 'shell', path: 'docker_install.sh'
      end
     if host[:netint] == 3
        node.vm.network :public_network, bridge: 'enp6s0'
        node.vm.provision 'shell', path: 'docker_install.sh'
      end


    end
    config.vm.synced_folder '.', '/vagrant', type: 'virtualbox'
    Vagrant::Config.run do |config|
      config.vbguest.auto_update = false
      config.vbguest.no_remote = true
    end
  end
end

