#!/bin/bash
read -p "Server Address: ";
if [ "$REPLY" != "" ]; then
	server=$REPLY
	read -p "Port: ";
	if [ "$REPLY" != "" ]; then
		serverIP=$(ping $server -c 1 | head -1 | awk '{print $3}' | sed 's/(//' | sed 's/)//')
		echo '------------------------------------------------------'
		echo 'Server IP: '$(echo $serverIP)
		echo $(nc -vz $server $REPLY)
	fi
fi
