#!/bin/bash
# mount:/var/www
LOCALTIME=/etc/localtime
if [ ! -L $LOCALTIME ]; then
  rm $LOCALTIME
  ln -s /usr/share/zoneinfo/Asia/Tokyo $LOCALTIME
fi
HOSTNAME=`hostname`
ROOT=/var/www/$HOSTNAME
HTML=$ROOT/html
REPO=mean
BASE=https://raw.githubusercontent.com/typista/docker-$REPO/master/files
if [ ! -e $HTML ]; then
	mkdir -p $HTML
	cp /tmp/app.js $HTML
	FRONT=$HTML/front
	DIST=$HTML/dist
	ANGULAR=$DIST/js/angular
	mkdir $FRONT
	mkdir -p $ANGULAR
	wget $BASE/index.html -O $FRONT
	wget $BASE/list.html -O $FRONT
	wget $BASE/edit.html -O $FRONT
	wget $BASE/angular.js -O $ANGULAR
	wget $BASE/angular.min.js -O $ANGULAR
	wget $BASE/angular-resource.js -O $ANGULAR
	wget $BASE/angular-resource.min.js -O $ANGULAR
	wget $BASE/angular-route.js -O $ANGULAR
	wget $BASE/angular-route.min.js -O $ANGULAR
	cd $HTML
	npm install -g grunt-cli
	npm install -g express && npm link express
	npm install -g body-parser && npm link body-parser
	npm install -g mongodb && npm link mongodb
fi
chown -R nginx: $ROOT

# mount:/var/log/nginx
LOG=/var/log/nginx/$HOSTNAME
if [ ! -e $LOG ]; then
	mkdir -p $LOG
fi
NGINX_CONF=/usr/local/nginx/conf/nginx.conf
ISDEFAULT=`grep $HOSTNAME $NGINX_CONF | wc -l`
if [ $ISDEFAULT -eq 0 ]; then
	sed -ri "s/__HOSTNAME__/$HOSTNAME/g" $NGINX_CONF
fi
chown -R nginx: $LOG

mkdir -p /data/db
/usr/bin/mongod &
crontab /root/crontab.txt
/etc/init.d/nginx start
/etc/init.d/crond start
/usr/bin/tail -f /dev/null
