#!/bin/bash
SCRIPT_PATH=$(dirname $(realpath $0))


#Restart always...
while :
do
	sudo python3 $SCRIPT_PATH/buttons.py
	sleep 1
done


