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

echo "`date` - Start NPM install of express" >> $BOOTSTRAP_LOG_FILE
sudo npm install forever express -g
echo "`date` - End NPM install of express" >> $BOOTSTRAP_LOG_FILE

if [ ! -d /vagrant/app/test-application ]; then
	cd /vagrant/app/
	express --sessions test-application
	sudo sed -i -e 's/\("jade": "\*"\)/\1, "mongodb": "*", "monk": "*"/g' /vagrant/app/test-application/package.json
	cd test-application
	npm install
	cp -r /vagrant/script/template/test-application/* /vagrant/app/test-application
fi

sudo -s <<HERE
 export PORT=80
 forever start -l /vagrant/logs/app/forever.log \
	-o /vagrant/logs/app/out.log \
	-e /vagrant/logs/app/err.log \
	-a \
	-w \
	--watchDirectory /vagrant/app/test-application/ \
	/vagrant/app/test-application/app.js
HERE

ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | grep -v '10.0.2' | grep -v '10.11.12.1' | cut -d: -f2 | awk '{ print "http://"$1"/"}' > /vagrant/logs/app/urls.txt
echo "You can access your application on "
cat /vagrant/logs/app/urls.txt

echo "`date` - Ended `echo $0` - OK" >> $BOOTSTRAP_LOG_FILE
