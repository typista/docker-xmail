#!/bin/sh
USER=typista
if [ "$1" = "" ];then
	echo "Input parametor FQDN [and TAG]"
else
	__FQDN__=$1
	__HOSTNAME__=`echo $__FQDN__ | sed -r "s/\./_/g"`
	CONTAINER=$__HOSTNAME__
	FULLPATH=$(cd `dirname $0`; pwd)/`basename $0`
	DIR=`dirname $FULLPATH`
	REPO=`basename $DIR`
	REPO=`echo $REPO | sed -r "s/docker\-//g"`
	IMAGE=$USER/$REPO
	HOST_IP=`ifconfig eth0 | awk '/inet /{print $2}' | sed -r "s/\./-/g"`
	__HOSTNAME__=${__HOSTNAME__}_$HOST_IP
	if [ "$2" != "" ];then
		IMAGE=$IMAGE:$2
	else
		VERSION=`docker images | grep "$IMAGE " | sort | tail -1 | awk '{print $2}'`
		if [ "$VERSION" != "" ];then
			IMAGE=$IMAGE:$VERSION
		fi
	fi
	docker run -d --privileged --restart=always --name="$__FQDN__" --hostname="$__HOSTNAME__" \
		-p 25:25 \
		-p 465:465 \
		-p 587:587 \
		-p 110:110 \
		-p 995:995 \
		-p 143:143 \
		-p 993:993 \
		-v ${PWD}/export:/root/export \
 		$IMAGE

	DIR_CONTAINER=dst/$__FQDN__
	if [ ! -e $DIR_CONTAINER ];then
		mkdir -p $DIR_CONTAINER
	fi

	RESTART=./restart.sh
	echo "docker rm -f $__FQDN__" > $RESTART
	echo "$0 $__FQDN__ &" >> $RESTART
	chmod +x $RESTART

	BOOT=./container/docker-boot-$CONTAINER.sh
	BOOT_OFF=./container/docker-boot-off-$CONTAINER.sh
	REMOVE=./container/docker-remove-$CONTAINER.sh
	echo "./docker-boot.sh $__FQDN__" > $BOOT
	echo "./docker-boot-off.sh $__FQDN__" > $BOOT_OFF
	echo "docker rm -f $__FQDN__" > $REMOVE
	echo "sudo rm -rf /var/www/$CONTAINER" >> $REMOVE
	chmod +x $BOOT
	chmod +x $BOOT_OFF
	chmod +x $REMOVE
	$BOOT
fi
