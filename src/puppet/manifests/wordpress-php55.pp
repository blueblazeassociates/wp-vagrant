
class { 'apache': }

include apt

package { [
  'git',
  'php5-cli',
  'php5-curl',
  'php5-gd',
  'php5-imagick',
  'php5-mcrypt',
  'php5-xdebug'
]:
  ensure => latest
}

include apache::mod::suphp

apache::mod { 'rewrite': }

apache::vhost { 'wordpress':
  servername       => $::fqdn,
  port             => '80',
  docroot          => '/vagrant/web',
  docroot_owner    => 'vagrant',
  docroot_group    => 'vagrant',
  override         => 'All',
  suphp_addhandler => 'application/x-httpd-suphp',
  suphp_engine     => 'on',
  suphp_configpath => '/etc/php5/cgi',
  custom_fragment  => 'EnableSendfile off
                       RewriteLogLevel 2
                       RewriteLog /var/log/apache2/rewrite.log'
}

apache::vhost { 'wordpress-ssl':
  servername       => $::fqdn,
  port             => '443',
  docroot          => '/vagrant/web',
  docroot_owner    => 'vagrant',
  docroot_group    => 'vagrant',
  override         => 'all',
  ssl              => true,
  suphp_addhandler => 'application/x-httpd-suphp',
  suphp_engine     => 'on',
  suphp_configpath => '/etc/php5/cgi',
  custom_fragment  => 'EnableSendfile off
                       RewriteLogLevel 2
                       RewriteLog /var/log/apache2/rewrite-ssl.log'
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
