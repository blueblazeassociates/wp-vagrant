#!/usr/bin/env bash

# Update Git to newer version.
# http://stackoverflow.com/a/25089430
# http://backports.debian.org/Instructions/#index2h2
sudo apt-get -qq -y -t wheezy-backports install "git"

# Tweak phpMyAdmin files to allow suphp to execute it.
# http://devkardia.com/blog/ubuntu-1004-suphp-and-phpmyadmin.html
sudo chown -R www-data:www-data /usr/share/phpmyadmin

# Copy php executable to php-cli. If all scripts use php-cli, this helps normalize commands across environments (Bluehost)
sudo ln -s /usr/bin/php5 /usr/bin/php-cli

# Add custom config for suphp.
sudo rm /etc/apache2/mods-available/suphp.conf
cp /vagrant/src/puppet/files/etc_apache2_mods-available_suphp.conf /etc/apache2/mods-available/suphp.conf

# Add custom config for php.
sudo rm /etc/php5/cgi/php.ini
cp /vagrant/src/puppet/files/etc_php5_cgi_php.ini /etc/php5/cgi/php.ini

# Replace php5-mysql with php5-mysqlnd
sudo apt-get install php5-mysqlnd -y

# Restart apache so it will take the above changes.
sudo service apache2 restart

# Add custom .bashrc for vagrant account.
sudo rm /home/vagrant/.bashrc
cp /vagrant/src/puppet/files/home_vagrant_bashrc /home/vagrant/.bashrc
sudo chown vagrant:vagrant .bashrc
sudo chmod 644 .bashrc

# Add custom .profile for vagrant account.
sudo rm /home/vagrant/.profile
cp /vagrant/src/puppet/files/home_vagrant_profile /home/vagrant/.profile
sudo chown vagrant:vagrant .profile
sudo chmod 644 .profile

# Add custom bash aliases for vagrant account.
cp /vagrant/src/puppet/files/home_vagrant_bash_aliases /home/vagrant/.bash_aliases
sudo chown vagrant:vagrant .bash_aliases
sudo chmod 644 .bash_aliases

# Disabled system beep!
# Thanks to http://linuxconfig.org/turn-off-beep-bell-on-linux-terminal
# Turn it off for Bash.
cp /vagrant/src/puppet/files/home_vagrant_inputrc /home/vagrant/.inputrc
sudo chown vagrant:vagrant .inputrc
sudo chmod 644 .inputrc
# Turn it off for vi.
cp /vagrant/src/puppet/files/home_vagrant_vimrc /home/vagrant/.vimrc
sudo chown vagrant:vagrant .vimrc
sudo chmod 644 .vimrc
