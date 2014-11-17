#!/bin/sh
if [ "$3" = "" ];then
	echo "Please enter DOMAIN and USER and PASSWORD"
	exit 2;
fi
DOMAIN_MASTER=$1
USER=$2
PASSWORD=$3

MAIL_TAB=/var/MailRoot/mailusers.tab
IS_EXIST=`cat $MAIL_TAB | grep '"'$DOMAIN_MASTER'"' | grep '"'$USER'"' | wc -l`
if [ "$IS_EXIST" = "" -o $IS_EXIST = 0 ];then
	#ユーザ追加
	/var/MailRoot/bin/CtrlClnt -s localhost -u $XMAILADMIN -p $XMAILPASS useradd $DOMAIN_MASTER $USER $PASSWORD U
fi

