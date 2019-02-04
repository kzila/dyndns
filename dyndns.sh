#!/bin/bash
source ./dyndns.cfg
LOGFILE="/var/log/dyndns-ip_change.log"

IPCKA="$(curl -s http://ipecho.net/plain)"
LASTIP=$(dig +noall +answer $DOMAIN |awk '{print $5}')

# Change IP if not equal to last/initial ip
if [[ $LASTIP != $IPCKA ]] ;then
	echo "Public IP changed from $LASTIP to $IPCKA ."
	curl "https://rest.websupport.sk/v1/user/$USERID/zone/$DOMAIN/record/$RECORDID" -H "Content-Type: application/json" -X PUT -d "{\"name\":\"@\",\"content\": \"${IPCKA}\",\"ttl\": 600}" -u $USERNAME:$PASSWORD
	echo "$(date) - $IPCKA" >> $LOGFILE
	echo "Your IP changed from $LASTIP to $IPCKA"
else 
	echo "Current public IP: $IPCKA is still the same."

fi
