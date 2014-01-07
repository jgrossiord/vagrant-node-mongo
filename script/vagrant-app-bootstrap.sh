#!/bin/bash -e
export BOOTSTRAP_LOG_FILE=/vagrant/logs/app/bootstrap.log
rm -f /vagrant/logs/app/*.log
rm -f /vagrant/logs/app/urls.txt

echo "`date` - Start `echo $0`" > $BOOTSTRAP_LOG_FILE

bash /vagrant/script/vagrant-bootstrap.sh $BOOTSTRAP_LOG_FILE


sudo apt-get install -y  -o dir::cache::archives="/vagrant/logs/apt-cache" python-software-properties 
sudo add-apt-repository ppa:chris-lea/node.js 
sudo apt-get update -y -o dir::cache::archives="/vagrant/logs/apt-cache"
sudo apt-get install -y  -o dir::cache::archives="/vagrant/logs/apt-cache" nodejs 

sudo npm install forever mongodb -g


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

echo "`date` - Ended `echo $0` - OK" >> $BOOTSTRAP_LOG_FILE
