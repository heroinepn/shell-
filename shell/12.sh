#!/bin/bash
#kill -user1 发送自定义USR1信号给Nginx进程，用于重新生成新的日志文件。
#这段代码的作用是将Nginx的日志文件进行归档，并重新生成新的日志文件，以便于管理和分析。
#其中，按照月份归档的日志文件目录可以帮助我们更加方便地查找和分析历史日志数据。

LOG_DIR=/usr/locsl/nginx/logs
YESTERDAY_TIME=$(date -d "yesterday" +%F)
LOG_MONTH_DIR=$LOG_DIR/$(date+"%Y-%m")
LOG_FILE_LIST="acess.log"
for LOG_FILE in LOG_FILE_LIST; do
	[ !-d $LOG_MONTH_DIR ] && mkdir -p $LOG_MONTH_DIR
	mv $LOG_DIR/$LOG_FILE  $LOG_MONTH_DIR/${LOG_FILE}_${YESTERDAY_TIME}
done
kill -user1$(cat /var/run/nginx.pid)