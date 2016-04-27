Vagrant LAMP stack
================

This is my base box. There are many like it, but this one is mine.


Installation
-----

`git clone --recursive git://github.com/hollsk/vagrant-lamp.git`
Uses name-based virtual hosts with wildcard directories, so you can map `http://root.snarfblat.lh` to the `config.vm.network` IP address in the vagrantfile, and it will use the contents of directory `/var/www/snarfblat` as the document root.

You will need to update your MYSQL config in the manifest to use your actual database configurations. TODO: come up with a sensible way of managing this, e.g. [hiera-eyaml][eyaml]


My memory is THE WORST, so I wrote down the steps what I took to build this box originally
-----

If I don't write it down, I'll have to do all this again one day and it'll take hours and hours and hours. Again.

- Install Virtualbox and Vagrant
- Initialise a new vagrant box, whatever is currently in fashion, e.g. `vagrant init ubuntu/trusty64; vagrant up --provider virtualbox`
- Edit initialised vagrant file
- `mkdir -p puppet/{manifests,modules}`
- `touch puppet/manifests/lamp.pp`
- Grab all the LAMP modules and their dependencies: 
```
# std dependencies 
git submodule add http://github.com/puppetlabs/puppetlabs-stdlib.git puppet/modules/stdlib
git submodule add https://github.com/puppetlabs/puppetlabs-concat.git puppet/modules/concat
git submodule add https://github.com/electrical/puppet-lib-file_concat.git puppet/modules/file_concat
git submodule add http://github.com/example42/puppi.git puppet/modules/puppi

# lamp stuff
git submodule add http://github.com/puppetlabs/puppetlabs-apache.git puppet/modules/apache
git submodule add http://github.com/puppetlabs/puppetlabs-mysql.git puppet/modules/mysql
git submodule add http://github.com/example42/puppet-php.git puppet/modules/php

# other useful stuff
git submodule add http://github.com/puppetlabs/puppetlabs-mongodb.git puppet/modules/mongodb
git submodule add http://github.com/puppetlabs/puppetlabs-nodejs.git puppet/modules/nodejs
git@github.com:
```
- Edit `puppet/manifests/lamp.pp` to do the important things it has to do. NB: this is the hard bit.
- `vagrant provision`
- `git init`
- Edit .gitignore 
- `git commit`, `push` etc
- Reward self with ice cream


TODO
-----

add node, phantomjs to manifest

[eyaml]: https://www.theguardian.com/info/developer-blog/2014/feb/14/encrypting-sensitive-data-in-puppet
