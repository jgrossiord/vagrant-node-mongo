#!/bin/bash -e

sudo apt-get update -y
#sudo apt-get upgrade -y
sudo apt-get install -y curl git
sudo apt-get install -y python-software-properties 
sudo add-apt-repository ppa:chris-lea/node.js 
sudo apt-get update -y
sudo apt-get install -y nodejs 

sudo npm install forever -g

rm -f /vagrant/logs/app/*.log
rm -f /vagrant/logs/app/urls.txt

sudo forever start -l /vagrant/logs/app/forever.log \
	-o /vagrant/logs/app/out.log \
	-e /vagrant/logs/app/err.log \
	-a \
	-w \
	--watchDirectory /vagrant/app/ \
	/vagrant/app/main.js

ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | grep -v '10.0.2' | grep -v '10.11.12.1' | cut -d: -f2 | awk '{ print "http://"$1"/"}' > /vagrant/logs/app/urls.txt
echo "You can access your application on "
cat /vagrant/logs/app/urls.txt
