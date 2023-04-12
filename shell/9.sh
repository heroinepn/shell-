#!/bin/bash
#mysql 主从同步 -e后可跟shell语句 
#登录主机master
HOST=localhost
USER=root
PASSWD=123.com
IO_SQL_STATUS=${mysql -h$HOST -u$USER -p$PASSWD -e 'show slave status\G' 
2>/dev/null |awk '/Slave_.*_Running:/{print $1$2}')
for i in IO_SQL_STATUS; do
	THREAD_STATUS_NAME=${i%:*}
	THREAD_STATUS=${i#*:}
	if [[ "$THREAD_STATUS" != "Yes" ]]; then
		echo "Error:Mysql-Slave $THREAD_STATUS_NAME satus is $THREAD_STATUS!" 
		|mail -s "Master-Slave Status" xx@163.com
	fi
done
#加入定时任务
crontab -e