#!/bin/sh
if [ "$2" = "" ];then
	echo "Please enter MASTER_DOMAIN and SUB_DOMAIN [and SSL_SELF_SIGNED]"
	exit
fi
cp /export/xmail /etc/init.d/
XMAIL=/var/MailRoot
if [ ! -L $XMAIL ];then
	if [ ! -d ~/export/MailRoot ];then
		mv $XMAIL ~/export/
	else
		mv $XMAIL $XMAIL.org
	fi
	ln -s ~/export/MailRoot $XMAIL
fi
export XMAILADMIN=xmailmaster
export XMAILPASS="stayfoo1ish"

USER=info
PASSWORD=wysiwyg

DOMAIN_MASTER=$1
DOMAIN_SUB=$2
DOMAIN_MAIL=$DOMAIN_SUB.$DOMAIN_MASTER


for SSL in server.key server.cert ssl.csr
do
    SSL=/root/export/`echo $SSL`
    echo $SSL
    if [ -f $SSL ];then
        mv $SSL ~/export/MailRoot/
    fi
done

cd ~/export/MailRoot/
if [ ! -f server.cert ];then
	if [ "$3" = "SSL_SELF_SIGNED" ];then
		openssl genrsa 2048 > ssl.key
		openssl rsa -in ssl.key -out server.key
		openssl req -new -key server.key -out ssl.csr
		openssl x509 -req -days 3650 -in ssl.csr -signkey server.key -out server.cert
	else
		echo "If you want to continue by self-signed ssl."
		echo "Please specify the 3rd parameter \"SSL_SELF_SIGNED\""
		exit
	fi
fi


IS_INIT_CTRL_ACCOUNTS_TAB=`grep $XMAILADMIN ctrlaccounts.tab | wc -l`
if [ $IS_INIT_CTRL_ACCOUNTS_TAB = 0 ];then
	echo -e "$XMAILADMIN\\t`bin/XMCrypt $XMAILPASS`" >> ctrlaccounts.tab
fi

#  SmtpServerDomain,POP3Domain,HeloDomainは、mail.等のサブドメイン
IS_INIT_SERVER_TAB=`grep xmailserver\.test server.tab | wc -l`
if [ $IS_INIT_SERVER_TAB != 0 ];then
	cp server.tab{,.org}
	#sed -i -r "s/(\"[SmtpServerDomain|POP3Domain|HeloDomain]\t\")xmailserver\.test/\1$DOMAIN_MAIL/g" server.tab
	sed -i -r "s/(SmtpServerDomain.+)xmailserver\.test/\1$DOMAIN_MAIL/g" server.tab
	sed -i -r "s/(POP3Domain.+)xmailserver\.test/\1$DOMAIN_MAIL/g" server.tab
	sed -i -r "s/(HeloDomain.+)xmailserver\.test/\1$DOMAIN_MAIL/g" server.tab
	sed -i -r "s/xmailserver.test/$DOMAIN_MASTER/g" server.tab

	# dockerブリッジのネットワークアドレスを追加
	PARENT_HOST_IP=`echo $HOSTNAME | awk -F '_' '{print $2}' | sed -r "s/\-/\./g"`
	PARENT_HOST_IP_CHECK=`grep $PARENT_HOST_IP server.tab | wc -l`
	if [ $PARENT_HOST_IP_CHECK = 0 ];then
  	echo -e \"SmtpConfig-$PARENT_HOST_IP\"  \"mail-auth=1\" >> server.tab
	fi
fi

# 以下のエントリがあると不正中継されるので削除
# "0.0.0.0" (TAB) "0.0.0.0"
IS_SMTPRELAY_NG=`grep '"'0\.0\.0\.0 smtprelay.tab | wc -l`
if [ $IS_SMTPRELAY_NG != 0 ];then
	cp smtprelay.tab{,.org}
	cat smtprelay.tab | grep -v '"'0\.0\.0\.0 > smtprelay.tab
fi

#smtprelay.tab
MY_IP=`ifconfig eth0 | awk '/inet /{print $2}' | awk -F ':' '{print $2}'`
MY_NW=`ifconfig eth0 | grep "inet " | awk '{print $4}' | awk -F ':' '{print $2}'`
MY_IP_CHECK=`grep $MY_IP smtprelay.tab | wc -l`
if [ $MY_IP_CHECK = 0 ];then
	echo \"$MY_IP\" \"$MY_NW\" >> smtprelay.tab
fi

#ctrl.ipmap.tab
IS_INIT_CTRL_IPMAP_TAB=`grep 0\.0\.0\.0 ctrl.ipmap.tab | grep ALLOW | wc -l`
if [ $IS_INIT_CTRL_IPMAP_TAB != 0 ];then
	echo -e "\"0.0.0.0\"\\t\"0.0.0.0\"\\t\"DENY\"\\t1" > ctrl.ipmap.tab
	echo -e "\"127.0.0.0\"\\t\"255.255.255.0\"\\t\"ALLOW\"\\t2" >> ctrl.ipmap.tab
fi

chmod +x /root/export/startXMail.sh
/root/export/startXMail.sh

#ドメイン追加
echo domain:$DOMAIN_MASTER
sh /root/export/domainadd.sh $DOMAIN_MASTER

#ユーザ追加
echo user:$USER
echo password:$PASSWORD
sh /root/export/useradd.sh $DOMAIN_MASTER $USER $PASSWORD

