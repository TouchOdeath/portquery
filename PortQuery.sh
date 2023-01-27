#!/bin/bash
if  [ "$#" -ne 2 ]; then
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
else
	OutputFile=.errorprog1.log
	if test -f "$OutputFile"; then
		rm OutputFile
	fi
	for ((i = 1 ; i < 255 ; i++ ));
	do
		serverIP="${1}.${i}"
		nc -vz -w 2 $serverIP $2 &>>OutputFile &
	done
	wait
	cat OutputFile | grep succeeded!
	rm OutputFile
fi
