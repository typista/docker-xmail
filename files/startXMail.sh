#/root/startXMail.sh
XMAIL=/etc/init.d/xmail

TEMP=/root/ps.tmp
ps aux > $TEMP
IS_XMAIL=`cat $TEMP | grep -v 'null' | grep '/var/MailRoot/bin/XMail'`
if [ -f $XMAIL -a "$IS_XMAIL" = "" ];then
    chmod +x $XMAIL
    $XMAIL start
fi
