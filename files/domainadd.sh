#!/bin/sh
if [ "$1" = "" ];then
	echo "Please enter DOMAIN"
	exit 1;
fi
DOMAIN_MASTER=$1

#ドメイン追加
/var/MailRoot/bin/CtrlClnt -s localhost -u $XMAILADMIN -p $XMAILPASS domainadd $DOMAIN_MASTER

