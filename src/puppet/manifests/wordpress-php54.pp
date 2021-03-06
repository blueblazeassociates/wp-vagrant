
class { 'apache': }

include apt

apt::source { 'wheezy_backports':
  location    => 'http://ftp.debian.org/debian',
  release     => 'wheezy-backports',
  repos       => 'main'
}

package { [
  'curl',
  'git',
  'php5-cli',
  'php5-curl',
  'php5-gd',
  'php5-imagick',
  'php5-mcrypt',
  'php5-xdebug',
  'php5-mysqlnd'
]: ensure => latest }

include apache::mod::suphp

apache::mod { 'rewrite': }

apache::vhost { 'wordpress':
  servername       => $::fqdn,
  port             => '80',
  docroot          => '/vagrant/web',
  docroot_owner    => 'vagrant',
  docroot_group    => 'vagrant',
  suphp_addhandler => 'application/x-httpd-suphp',
  suphp_engine     => 'on',
  suphp_configpath => '/etc/php5/cgi',
  override         => 'All',
  custom_fragment  => 'RewriteLogLevel 2
                       RewriteLog /var/log/apache2/rewrite.log
                       EnableSendfile off'
}

apache::vhost { 'wordpress-ssl':
  servername       => $::fqdn,
  port             => '443',
  docroot          => '/vagrant/web',
  docroot_owner    => 'vagrant',
  docroot_group    => 'vagrant',
  ssl              => true,
  suphp_addhandler => 'application/x-httpd-suphp',
  suphp_engine     => 'on',
  suphp_configpath => '/etc/php5/cgi',
  override         => 'All',
  custom_fragment  => 'RewriteLogLevel 2
                       RewriteLog /var/log/apache2/rewrite-ssl.log
                       EnableSendfile off'
}

class { 'mysql::server':
  root_password => 'wordpress'
}

class { 'mysql::bindings':
  php_enable => 'true',
}

mysql::db { ['wordpress']:
  ensure   => present,
  charset  => 'utf8mb4',
  collate  => 'utf8mb4_unicode_ci',
  user     => 'wordpress',
  password => 'wordpress',
  host     => 'localhost',
  grant    => ['ALL'],
  require  => Class['mysql::server']
}

# Thanks to https://github.com/tombevers/vagrant-puppet-LAMP/blob/master/modules/phpmyadmin/manifests/init.pp
# and others...
class phpmyadmin {
  package { "phpmyadmin":
    ensure => present,
    require => Package["php5-mysqlnd", "apache2"],
  }

  file { "/etc/apache2/conf.d/phpmyadmin.conf":
    ensure => link,
    target => "/etc/phpmyadmin/apache.conf",
    require => Package['apache2'],
    notify => Service["apache2"]
  }
}

include phpmyadmin

# Thanks to http://ryansechrest.com/2014/08/wordpress-establish-secure-connection-wordpress-org/
host { "api.wordpress.org":
  ip => "66.155.40.249",
}

# Add Envato update service to hosts file.
host { "marketplace.envato.com":
  ip => "23.209.92.106",
}

# Add ACF update service to hosts file.
host { "connect.advancedcustomfields.com":
  ip => "108.174.159.113",
}

# Thanks to http://stackoverflow.com/a/25728814
# and http://serverfault.com/a/399885
user { 'vagrant':
  shell => '/bin/bash',
}
