#!/usr/bin/env bash

# Set timezone to Eastern US time - Method #1
sudo rm /etc/timezone
sudo cp /vagrant/src/puppet/files/etc_timezone /etc/timezone
	
# Set timezone to Eastern US time - Method #2
sudo rm /etc/localtime
sudo ln -s /usr/share/zoneinfo/US/Eastern /etc/localtime

# Add DotDeb repository to apt-get
# http://www.dotdeb.org/instructions/
  # 1: Insert custom apt-get sources.
rm /etc/apt/sources.list
cp /vagrant/src/puppet/files/etc_apt_sources.list /etc/apt/sources.list
  # 2: Download GnuPG key for dotdeb.
wget --output-document=/tmp/dotdeb.gpg http://www.dotdeb.org/dotdeb.gpg
  # 3: Add GnuPG key to apt-get system.
apt-key add /tmp/dotdeb.gpg

apt-get update --fix-missing

# Insert custom suphp configuration.
mkdir -p /etc/suphp
cp /vagrant/src/puppet/files/etc_suphp_suphp.conf /etc/suphp/suphp.conf

# Install Puppet's APT tools.
if [ ! -d /etc/puppet/modules/apt ]; then
	puppet module install puppetlabs/apt;
fi

# Install Apache.
if [ ! -d /etc/puppet/modules/apache ]; then
	puppet module install puppetlabs/apache;
fi

# Install MySQL.
if [ ! -d /etc/puppet/modules/mysql ]; then
	puppet module install puppetlabs/mysql;
fi

# Install PHPUnit.
if [ ! -f /usr/local/bin/phpunit ]; then
	curl --silent --show-error --location --output /usr/local/bin/phpunit https://phar.phpunit.de/phpunit-4.8.5.phar
fi

chmod +x /usr/local/bin/phpunit
