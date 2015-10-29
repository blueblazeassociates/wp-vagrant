# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

#
# PHP 5.4
#
  config.vm.define 'WP.PHP54', primary: true do |node|
    node.vm.box = 'blueblazeassociates/debian-7.8-64-puppet'
    node.vm.hostname = 'wordpress-php54.vagrant'
    node.vm.network :private_network, ip: '192.168.255.54'

    node.vm.provider :virtualbox do |vb|
      vb.customize [
        'modifyvm', :id,
        '--paravirtprovider', 'kvm',
        '--memory', '1024',
        '--cpus', '1',
        '--cpuexecutioncap', '100',
      ]
      vb.customize [
        'guestproperty', 'set', :id,
        '/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold', 60000
      ]
    end

    node.vm.provision :shell, :path => "src/puppet/bootstrap.sh"
    node.vm.provision :puppet do |puppet|
      puppet.facter = { 'fqdn' => node.vm.hostname }
      puppet.manifests_path = "src/puppet/manifests"
      puppet.manifest_file  = "wordpress-php54.pp"
      puppet.options = "--hiera_config /etc/hiera.yaml"
    end
    node.vm.provision :shell, :path => "src/puppet/followup.sh"
  end

#
# PHP 5.2
#
#  config.vm.define 'WP.PHP52', autostart: false do |node|
#    node.vm.box = 'tierra/wordpress-php52'
#    node.vm.hostname = 'wordpress-php52.vagrant'
#    node.vm.network :private_network, ip: '192.168.255.52'
#
#    node.vm.provider :virtualbox do |vb|
#      vb.customize [
#        'modifyvm', :id,
#        '--paravirtprovider', 'kvm',
#        '--memory', '1024',
#        '--cpus', '1',
#        '--cpuexecutioncap', '100',
#      ]
#    end
#  end

#
# PHP 5.3
#
#  config.vm.define 'WP.PHP53', autostart: false do |node|
#    node.vm.box = 'puppetlabs/ubuntu-12.04-64-puppet'
#    node.vm.hostname = 'wordpress-php53.vagrant'
#    node.vm.network :private_network, ip: '192.168.255.53'
#
#    node.vm.provider :virtualbox do |vb|
#      vb.customize [
#        'modifyvm', :id,
#        '--paravirtprovider', 'kvm',
#        '--memory', '1024',
#        '--cpus', '1',
#        '--cpuexecutioncap', '100',
#      ]
#    end
#
#    node.vm.provision :shell, :path => "src/puppet/bootstrap.sh"
#    node.vm.provision :puppet do |puppet|
#      puppet.facter = { 'fqdn' => node.vm.hostname }
#      puppet.manifests_path = "src/puppet/manifests"
#      puppet.manifest_file  = "wordpress-php53.pp"
#      puppet.options = "--hiera_config /etc/hiera.yaml"
#    end
#  end

#
# PHP 5.5
#
#  config.vm.define 'WP.PHP55', autostart: false do |node|
#    node.vm.box = 'puppetlabs/ubuntu-14.04-64-puppet'
#    node.vm.hostname = 'wordpress-php55.vagrant'
#    node.vm.network :private_network, ip: '192.168.255.55'
#
#    node.vm.provider :virtualbox do |vb|
#      vb.customize [
#        'modifyvm', :id,
#        '--paravirtprovider', 'kvm',
#        '--memory', '1024',
#        '--cpus', '1',
#        '--cpuexecutioncap', '100',
#      ]
#    end
#
#    node.vm.provision :shell, :path => "src/puppet/bootstrap.sh"
#    node.vm.provision :puppet do |puppet|
#      puppet.facter = { 'fqdn' => node.vm.hostname }
#      puppet.manifests_path = "src/puppet/manifests"
#      puppet.manifest_file  = "wordpress-php55.pp"
#      puppet.options        = "--hiera_config /etc/hiera.yaml"
#    end
#  end

end
