#!/bin/sh
if [ "$3" = "" ];then
	echo "Please enter DOMAIN and USER and PASSWORD"
	exit 2;
fi
DOMAIN_MASTER=$1
USER=$2
PASSWORD=$3

#ユーザ追加
bin/CtrlClnt -s localhost -u $XMAILADMIN -p $XMAILPASS useradd $DOMAIN_MASTER $USER $PASSWORD U

