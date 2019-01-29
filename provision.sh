#!/bin/bash

sudo apt-get update

# default packages
sudo apt-get install -y git-core curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev imagemagick

# rbenv & ruby
sudo -u vagrant git clone https://github.com/rbenv/rbenv.git /home/vagrant/.rbenv
sudo -u vagrant echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/vagrant/.bashrc
sudo -u vagrant echo 'eval "$(rbenv init -)"' >> /home/vagrant/.bashrc
sudo -u vagrant -i exec $SHELL

sudo -u vagrant git clone https://github.com/rbenv/ruby-build.git /home/vagrant/.rbenv/plugins/ruby-build
sudo -u vagrant echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> /home/vagrant/.bashrc
sudo -u vagrant -i exec $SHELL

# no rdoc for installed gems
sudo -u vagrant echo 'gem: --no-ri --no-rdoc' >> /home/vagrant/.gemrc

# install ruby
sudo -u vagrant -i /home/vagrant/.rbenv/bin/rbenv install 2.3.1
sudo -u vagrant -i /home/vagrant/.rbenv/bin/rbenv global 2.3.1
sudo -u vagrant -i /home/vagrant/.rbenv/versions/2.3.1/bin/gem install bundler --no-ri --no-rdoc
sudo -u vagrant -i /home/vagrant/.rbenv/versions/2.3.1/bin/bundle config git.allow_insecure true

# nodejs
sudo apt-get install -y nodejs
sudo apt-get install -y npm
sudo ln -s /usr/bin/nodejs /usr/bin/node
sudo npm install -g npm

# rails
sudo -u vagrant -i /home/vagrant/.rbenv/versions/2.3.1/bin/gem install rails --no-ri --no-rdoc
sudo -u vagrant -i /home/vagrant/.rbenv/versions/2.3.1/bin/gem install pry

# rehash
sudo -u vagrant -i /home/vagrant/.rbenv/bin/rbenv rehash

# mysql
debconf-set-selections <<< 'mysql-server mysql-server/root_password password Qwerty'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password Qwerty'
sudo apt-get install -y mysql-server mysql-client libmysqlclient-dev

# postgresql
sudo apt-get install  -y postgresql postgresql-client postgresql-contrib libpq-dev
sudo sh -c "echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.*/main/pg_hba.conf"
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'Qwerty';"
sudo -u postgres psql -c "CREATE ROLE vagrant SUPERUSER LOGIN PASSWORD 'vagrant';"

# redis
sudo apt-get install -y build-essential tcl
sudo add-apt-repository ppa:chris-lea/redis-server -y && sudo apt-get update && sudo apt-get install -y redis-server
