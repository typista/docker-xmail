#!/bin/sh
if [ "$3" = "" ];then
	echo "Please input DOMAIN USER PASSWORD(NEW)"
	exit
fi
DOMAIN=$1
USER=$2
PASSWORD=$3

HASH_OLD=`cat /var/MailRoot/mailusers.tab | grep $DOMAIN | grep $USER | awk '{print $3}'`
HASH_NEW=`/var/MailRoot/bin/XMCrypt $PASSWORD`

sed -i -r "s/($DOMAIN.+$USER.+)$HASH_OLD/\1\"$HASH_NEW\"/g" /var/MailRoot/mailusers.tab
