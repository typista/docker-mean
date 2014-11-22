#!/bin/sh
BIN=/usr/bin/forever
APP=/var/www/`hostname`/html/index.js
IS_EXEC=`cat $TEMP | grep -v 'null' | grep '/usr/bin/node /usr/lib/node_modules/forever/bin/monitor'`
if [ -f $BIN -a "$IS_EXEC" = "" ];then
    $BIN start $APP
fi

