#!/bin/bash
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
  rm $LOCALTIME
  ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi

/root/startXMail.sh
/etc/init.d/crond start
crontab /root/crontab.txt
/usr/bin/tail -f /dev/null
