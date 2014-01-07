#!/bin/bash -e
export DEBIAN_FRONTEND=noninteractive

echo "`date` - Start apt-get update" >> $1
sudo apt-get update -y
echo "`date` - End apt-get update" >> $1

echo grub-pc grub-pc/install_devices multiselect /dev/sda | sudo debconf-set-selections
echo grub-pc grub-pc/install_devices_disks_changed multiselect /dev/sda | sudo debconf-set-selections

echo "`date` - Start apt-get upgrade" >> $1
sudo apt-get upgrade -y -o dir::cache::archives="/vagrant/logs/apt-cache"
echo "`date` - End apt-get upgrade" >> $1

echo "`date` - Start apt-get install common tools" >> $1
sudo apt-get install -y  -o dir::cache::archives="/vagrant/logs/apt-cache" curl git
echo "`date` - End apt-get install common tools" >> $1
