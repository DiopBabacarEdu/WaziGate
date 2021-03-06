#!/bin/bash
# Installing the WaziGate framework on your device for development
# @author: Mojiz 21 Jun 2019

#read -p "This script will download and install the development version of the Wazigate. Continue (y/n)? "
#echo
#if [[ ! $REPLY =~ ^[Yy]$ ]]
#then
#    echo "Existing."
#    [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
#fi

#--------------------------------#

echo "Changing the password: "
echo -e "loragateway\nloragateway" | sudo passwd $USER
echo "Done."

#--------------------------------#

#Packages
sudo apt-get update
sudo apt-get install -y git golang

#--------------------------------#

#installing wazigate
#Using HTTP makes us to clone without needing persmission via ssh-keys
#git clone --recursive https://github.com/Waziup/waziup-gateway.git waziup-gateway
git clone https://github.com/Waziup/waziup-gateway.git waziup-gateway
cd waziup-gateway
#Fetch the latest version of submodules
git submodule update --init --recursive --remote


#--------------------------------#

bash ./setup/install.sh

#--------------------------------#


sudo sed -i 's/^DEVMODE.*/DEVMODE=1/g' start.sh
sudo chmod +x start.sh
sudo chmod +x stop.sh

#--------------------------------#
# Adding FTP
sudo apt-get install -y git pure-ftpd
sudo groupadd ftpgroup
sudo usermod -a -G ftpgroup $USER
sudo chown -R $USER:ftpgroup "$PWD"
sudo pure-pw useradd upload -u $USER -g ftpgroup -d "$PWD" -m <<EOF
loragateway
loragateway
EOF
sudo pure-pw mkdb
sudo service pure-ftpd restart

#--------------------------------#

echo "Building the docker images..."
sudo docker-compose -f docker-compose.yml -f docker-compose-dev.yml build --force-rm

for i in {10..01}; do
	echo -ne "Installation finished. Rebooting in $i seconds... \033[0K\r"
	sleep 1
done
sudo reboot

exit 0;
