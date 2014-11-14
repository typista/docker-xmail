#!/bin/sh
USER=typista
FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
DIR=`dirname $FULLPATH`
REPO=`basename $DIR`
IMAGE=$USER/$REPO
if [ "$1" != "" ];then
	IMAGE=$IMAGE:$1
fi
SSL=dst/ssl
if [ ! -e $SSL ];then
	mkdir -p $SSL
fi
if [ ! -f $SSL/server.cert ];then
	openssl genrsa -des3 > $SSL/ssl.key
	openssl rsa -in $SSL/ssl.key -out $SSL/server.key
	openssl req -new -key $SSL/server.key -out $SSL/ssl.csr
	openssl x509 -req -days 3650 -in $SSL/ssl.csr -signkey $SSL/server.key -out $SSL/server.cert
fi
if [ ! -f $SSL/server.cert -o ! -f $SSL/ssl.csr -o ! -f $SSL/server.key -o ! -f $SSL/ssl.key ];then
	echo "Check for [dst/ssl/]"
	exit
fi
docker build -t $IMAGE .
