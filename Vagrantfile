# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagrantfile for lorvet-Vagrant
# ---------------------------------
#
# This file contains the Vagrant configurations for provisioning a lorvet
# development instance. Vagrant file uses Ruby as a configuration language.
#
# The file's structure and content are described in the Vagrant docs:
# http://docs.vagrantup.com/v2/vagrantfile/index.html
#
# If you would like to customize the configuration of your Virtual Machine,
# rather than override the values defined in this file, simply create a file
# called 'Vagrantfile-extra.rb' in this folder and it will be automatically
# loaded. In case of conflict, values in the 'extra' file will superceded
# any values in this file. 'Vagrantfile-extra.rb' is ignored by git.
#
$DIR = File.expand_path('..', __FILE__); $: << File.join($DIR, 'lib')

$JOB_ID = $JOB_ID || ""

if !defined?($JOB_ID) || ($JOB_ID == '') then
  if ENV.has_key?("JOB_ID") then
    $JOB_ID = ENV['JOB_ID']
  end
end

Vagrant.configure('2') do |config|
  config.vm.hostname = 'lorvet-vagrant.dev'
  config.package.name = 'lorvet.box'

  config.vm.box = 'trusty-cloud'
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
  if config.vm.respond_to? 'box_download_insecure' # Vagrant 1.2.6+
    config.vm.box_download_insecure = true
  end

  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  config.vm.network :private_network,
    ip: '10.0.1.3'

  config.vm.synced_folder '.', '/vagrant',
    id: 'vagrant-root',
    owner: 'vagrant',
    group: 'www-data'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
    vb.customize ['modifyvm', :id, '--cpus', '2']

    # This allows symlinks to be created within the /vagrant root directory,
    # which is something librarian-puppet needs to be able to do. This might
    # be enabled by default depending on what version of VirtualBox is used.
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/v-root", "1"]
  end

  config.vm.provision :shell, :path => "scripts/puppet.sh"

  config.vm.provision :puppet do |puppet|
    puppet.module_path = ["puppet/modules", "puppet/vendor"]
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.working_directory = "/vagrant"
    puppet.options = [
      '--verbose',
      '--logdest', "/vagrant/logs/puppet/puppet.log",
      '--logdest', 'console',
      '--hiera_config', '/vagrant/hiera.yaml',
    ]

    puppet.facter = {
      # Specifying the LANG environment variable this way is a work around.
      # The work around can be removed when this issue is fixed https://github.com/mitchellh/vagrant/issues/2270
      "anything=anything LANG=en_US.UTF-8 anything" => "anything",
      "job_id" => $JOB_ID
    }

    # For more output, uncomment the following line:
    # puppet.options << '--debug'
  end

  config.vm.define "lorvetdev" do |web|
  end
end

begin
    # Load custom Vagrantfile overrides from 'Vagrantfile-extra.rb'
    # See 'support/Vagrantfile-extra.rb' for an example.
    require File.join($DIR, 'Vagrantfile-extra')
rescue LoadError
    # OK. File does not exist.
end
