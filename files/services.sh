#!/bin/bash
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
  rm $LOCALTIME
  ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi

if [ -f /var/MailRoot/server.cert ];then
	/etc/init.d/xmail start
fi

/etc/init.d/crond start
/usr/bin/tail -f /dev/null
