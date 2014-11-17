#!/bin/sh
if [ "$1" = "" ];then
	echo "Please enter DOMAIN"
	exit 1;
fi
DOMAIN_MASTER=$1

DOMAINS_TAB=/var/MailRoot/domains.tab
IS_EXIST=`cat $DOMAINS_TAB | grep '"'$DOMAIN_MASTER'"' | wc -l`
if [ "$IS_EXIST" = "" -o $IS_EXIST = 0 ];then
	/var/MailRoot/bin/CtrlClnt -s localhost -u $XMAILADMIN -p $XMAILPASS domainadd $DOMAIN_MASTER
fi
