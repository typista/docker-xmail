#!/bin/bash
REPO=docker-xmail
URL=https://raw.githubusercontent.com/typista/$REPO/master/files
EXPORT=/root/export
DOWNLOADS="exec1st.sh startXMail.sh crontab.txt domainadd.sh useradd.sh changepassword.sh"
for FILE in $DOWNLOADS
do
    DONE=$EXPORT/$FILE
    if [ ! -f $DONE -a ! -s $DONE ];then
        wget $URL/$FILE -O $DONE
    fi
    if [ ! -x $DONE ];then
        chmod +x $DONE
    fi
done

EXEC1ST=$EXPORT/exec1st.sh
wget $URL/exec1st -O $EXEC1ST
if [ ! -x $EXEC1ST ];then
    chmod +x $EXEC1ST
fi

$EXEC1ST
crontab $EXPORT/crontab.txt
/etc/init.d/crond start
/usr/bin/tail -f /dev/null

