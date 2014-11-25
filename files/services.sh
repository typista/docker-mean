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
BASE=https://raw.githubusercontent.com/typista/docker-$REPO/master/files/html
if [ ! -e $HTML ]; then
	mkdir -p $HTML
	FRONT=$HTML/front
	DIST=$HTML/dist
	ANGULAR=$DIST/js/angular
	mkdir $FRONT
	mkdir -p $ANGULAR
	wget $BASE/index.js -O $HTML/index.js
	wget $BASE/front/index.html -O $FRONT/index.html
	wget $BASE/front/list.html -O $FRONT/list.html
	wget $BASE/front/edit.html -O $FRONT/edit.html
	wget $BASE/dist/js/angular/angular.js -O $ANGULAR/angular.js
	wget $BASE/dist/js/angular/angular.min.js -O $ANGULAR/angular.min.js
	wget $BASE/dist/js/angular/angular-resource.js -O $ANGULAR/angular-resource.js
	wget $BASE/dist/js/angular/angular-resource.min.js -O $ANGULAR/angular-resource.min.js
	wget $BASE/dist/js/angular/angular-route.js -O $ANGULAR/angular-route.js
	wget $BASE/dist/js/angular/angular-route.min.js -O $ANGULAR/angular-route.min.js
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
