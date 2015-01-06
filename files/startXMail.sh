#/root/startXMail.sh
XMAIL=/etc/init.d/xmail

TEMP=/root/ps.tmp
ps aux > $TEMP
MAIL_ROOT_VAR=/var/MailRoot
MAIL_ROOT_EXPORT=/root/export/MailRoot
if [ ! -L $MAIL_ROOT_VAR -a -e $MAIL_ROOT_EXPORT ]; then
	if [ -e $MAIL_ROOT_VAR ]; then
		rm -rf $MAIL_ROOT_VAR
	fi
	ln -s $MAIL_ROOT_EXPORT $MAIL_ROOT_VAR
fi
IS_XMAIL=`cat $TEMP | grep -v 'null' | grep '/var/MailRoot/bin/XMail'`
if [ -f $XMAIL -a "$IS_XMAIL" = "" ];then
    chmod +x $XMAIL
    $XMAIL start
fi
