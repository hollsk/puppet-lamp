$docroot = '/var/www/'
 
# Apache setup
class { 'apache':
	mpm_module => 'prefork',
	root_directory_options => [
		'Indexes',
		'FollowSymlinks',
		'MultiViews'
	],
}
class { 'apache::mod::php': }

apache::vhost { '*:80':
	servername => 'default',
	serveraliases => [
		'root.*.lh'
	],
	virtual_docroot => '/var/www/%2',
	directoryindex => 'index.php index.htm index.html',
	override => ['all'],
    priority => '20',
    port => '80',
    docroot => $docroot,
	docroot_owner => 'www-data',
	docroot_group => 'www-data',
}

# Apache modules
class { 'apache::mod::expires': }
class { 'apache::mod::headers': }
class { 'apache::mod::rewrite': }
class { 'apache::mod::vhost_alias': }


# PHP setup
include php
php::module { ['xdebug', 'pgsql', 'curl', 'gd', 'cli', 'intl', 'mcrypt', 'cgi', 'imagick', 'mysql', 'mysqlnd','xsl'] : 
    notify => [ Service['httpd'], ],
}
#php::pecl::module { 'pecl_http': }
php::pecl::module { 'oauth': }

# the mcrypt symlink doesn't seem to get created automatically, so do it manually
file { '/etc/php5/apache2/conf.d/20-mcrypt.ini':
    ensure => 'link',
    target => '/etc/php5/mods-available/mcrypt.ini',
    require => [
        Package['php5-mcrypt'],
    ],
}

# MYSQL setup
include '::mysql::client'
class { '::mysql::server':
    root_password    => 'root',
    remove_default_accounts => true,
    override_options => {
        'mysqld' => {
            'max_connections'   => '1024',
            'key_buffer_size'   => '512M'       
        }       
    },
    databases => {
        'justSomeTestDB' => {
            ensure => 'present',
            charset => 'utf8'
        }
    },
    users => {
        'prefix_user@localhost' => {
            ensure => present,
            password_hash => mysql_password('superDuperStrongPW')
        },
        'prefix_user@%' => {
            ensure => present,
            password_hash => mysql_password('superDuperStrongPW')
        }
    },
    grants => {
        'prefix_user@%/*.*' => {
            ensure     => 'present',
            options    => ['GRANT'],
            privileges => ['ALL'],
            table      => '*.*',
            user       => 'prefix_user@%',
        },
    },    
}


