#!/bin/bash
#-s 去掉边框线条 egrep -v 过滤数据库-p 确保目录名称存在，不存在的就建一个。
DATE=$(date +%F_%H-%M-%S)
HOST=localhost
USER=backup
PASS=123.com
BACKUP_DIR=/data/db_backup
DB_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "show databases;" 2>/dev/null |
	egrep -v "Database |informstion_schema|mysql|performance_schema|sys")
for DB in $DB_LIST; do
	BACKUP_NAME=$BACKUP_DIR/${DB}_${DATE}.sql 
	if ! mysqldump -h$HOST -u$USER -p$PASS -B $DB >$BACKUP_NAME 2>/dev/null; 
	then
		echo "$BACKUP_NAME 备份失败"
	fi
done

#!/bin/bash
#分表备份 -d目录测试存在的命令
DATE=$(date +%F_%H-%M-%S)
HOST=localhost
USER=backup
PASS=123.com
BACKUP_DIR=/data/db_backup
DB_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e "show databases;" 2>/dev/null |
	egrep -v "Database |informstion_schema|mysql|performance_schema|sys")
for DB in $DB_LIST; do
	BACKUP_DB_DIR=$BACKUP_DIR/${DB}_${DATE}
	[ ! -d $BACKUP_DB_DIR] && mkdir -p $BACKUP_DB_DIR &>/dev/null
	TABLE_LIST=$(mysql -h$HOST -u$USER -p$PASS -s -e"use $DB;show tables;" 
		2>/dev/null)
    for TABLE in $TABLE_LIST; do
		BACKUP_NAME=$BACKUP_DB_DIR/${TABLE}.sql 
	
	if ! mysqldump -h$HOST -u$USER -p$PASS -B $DB $TABLE>$BACKUP_NAME 
		2>/dev/null; then
		echo "$BACKUP_NAME 备份失败"
	fi
done
done