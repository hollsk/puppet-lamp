class { 'nodejs': }

# ubuntu uses a silly package name, so create a symlink to "node"
file { '/usr/bin/node':
    ensure => 'link',
    target => '/usr/bin/nodejs',
}

package { 'phantomjs-prebuilt':
    provider => 'npm',
    ensure   => 'present',
}