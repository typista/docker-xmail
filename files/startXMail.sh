#/root/startXMail.sh
XMAIL=/etc/init.d/xmail
IS_XMAIL=`ps aux | grep XMail | grep -v "grep XMail" | wc -l`
if [ -f $XMAIL -a $IS_XMAIL = 0 ];then
    chmod +x $XMAIL
    $XMAIL start
fi
