#!/bin/bash

ROOT_DIR=$( dirname "$( cd "$( dirname "${BASH_SOURCE[0]}")" && pwd)" );

# Directory in which librarian-puppet should manage its vendor directory
PUPPET_DIR=$ROOT_DIR/puppet

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum

$(which apt-get > /dev/null 2>&1)
FOUND_APT=$?

$(which git > /dev/null 2>&1)
FOUND_GIT=$?
if [ "$FOUND_GIT" -ne '0' ]; then
  echo 'Attempting to install git.'
  if [ "${FOUND_APT}" -eq '0' ]; then
    sudo apt-get -q -y update
    sudo apt-get -q -y install git
    echo 'git installed.'
  else
    echo 'No package installer available. You may need to install git manually.'
  fi
fi

$(which gem > /dev/null 2>&1)
FOUND_GEM=$?
if [ "$FOUND_GEM" -ne '0' ]; then
  echo 'Attempting to install rubygems.'
  if [ "${FOUND_APT}" -eq '0' ]; then
    sudo apt-get -q -y update
    sudo apt-get -q -y install rubygems
    echo 'rubygems installed.'
  else
    echo 'No package installer available. You may need to install rubygems manually.'
  fi
fi

if [ "${FOUND_APT}" -eq '0' ]; then
  sudo apt-cache showpkg build-essential | grep '/var/lib/dpkg/status' >/dev/null || \
    sudo apt-get -q -y install build-essential
  sudo apt-cache showpkg ruby-dev | grep '/var/lib/dpkg/status' >/dev/null || \
    sudo apt-get -q -y install ruby-dev
fi

sudo gem install librarian-puppet --no-rdoc --no-ri -v 1.0.0
cd $PUPPET_DIR && sudo librarian-puppet install --path=vendor
