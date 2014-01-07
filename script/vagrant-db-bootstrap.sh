#!/bin/bash -e
export BOOTSTRAP_LOG_FILE=/vagrant/logs/db/bootstrap.log
rm -f /vagrant/logs/db/*.log
rm -f /vagrant/logs/db/urls.txt


echo "`date` - Start `echo $0`" > $BOOTSTRAP_LOG_FILE

bash /vagrant/script/vagrant-bootstrap.sh $BOOTSTRAP_LOG_FILE

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 >> $BOOTSTRAP_LOG_FILE

if [ ! -a /etc/apt/sources.list.d/mongodb.list ]; then
	echo "Adding mongo repo into /etc/apt/sources.list.d/mongodb.list" >> $BOOTSTRAP_LOG_FILE
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
	sudo apt-get update -y -o dir::cache::archives="/vagrant/logs/apt-cache"
fi

echo "`date` - Start Install mongodb-10gen" >> $BOOTSTRAP_LOG_FILE
sudo apt-get install -y -o dir::cache::archives="/vagrant/logs/apt-cache" mongodb-10gen
echo "`date` - Ended Install mongodb-10gen" >> $BOOTSTRAP_LOG_FILE

echo "`date` - Ended `echo $0` - OK" >> $BOOTSTRAP_LOG_FILE

