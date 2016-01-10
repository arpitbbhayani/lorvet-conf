#!/bin/bash

PUPPET_MAJOR_VERSION=$(puppet --version 2>/dev/null | cut -d'.' -f1)
if [ "${PUPPET_MAJOR_VERSION}x" != "3x" ]; then
  $(which apt-get > /dev/null 2>&1)
  FOUND_APT=$?
  if [ "${FOUND_APT}" -eq '0' ]; then
    sudo apt-get install --yes lsb-release
    DISTRIB_CODENAME=$(lsb_release --codename --short)
    DEB="puppetlabs-release-${DISTRIB_CODENAME}.deb"
    DEB_PROVIDES="/etc/apt/sources.list.d/puppetlabs.list" # Assume that this file's existence means we have the Puppet Labs repo added

    if [ ! -e $DEB_PROVIDES ]
    then
        # Print statement useful for debugging, but automated runs of this will interpret any output as an error
        # print "Could not find $DEB_PROVIDES - fetching and installing $DEB"
        wget -q http://apt.puppetlabs.com/$DEB
        sudo dpkg -i $DEB
        rm $DEB
    fi
    sudo apt-get update
    sudo apt-get install --yes puppet
    yes | sudo dpkg-reconfigure locales
  else
    $(which gem > /dev/null 2>&1)
    FOUND_GEM=$?
    if [ "$FOUND_GEM" -eq '0' ]; then
      sudo gem install puppet --no-rdoc --no-ri
    else
      echo 'No package installer available. You may need to install rubygems manually.'
    fi
  fi
fi

PUPPET_CONF=/etc/puppet/puppet.conf
sudo sed -i '/^\s*templatedir=/d' $PUPPET_CONF 2>/dev/null || true
