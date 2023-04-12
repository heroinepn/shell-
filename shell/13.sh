#!/bin/bash
#exit 1退出脚本,NR==1 定位在file的第一行,egrep -v 条件取反，-n是否为空，不为空则为true
#`$TOMCAT_PID` 变量的值是否为空，如果不为空，则执行 `kill -9` 命令杀死对应的进程。
#`grep|$$` 是一个正则表达式，其中的管道符 `|` 表示逻辑或的关系。
#首先使用 `egrep` 命令过滤掉包含字符串 "grep" 或当前进程 ID 的行，这里的 `$$` 表示当前进程 ID。
#$1 传参Tomcat名称
DATE=$(date +%F_+%T)
TOMCAT_NAME=$1
TOMCAT_DIR=/usr/local/$TOMCAT_NAME
ROOT=$TOMCAT_DIR/webapps/ROOT
BACKUP_DIR=/date/backup
WORK_DIR=/tmp
PROJECT_NAME=tomcat-java-demo
#拉取代码
cd $WORK_DIR
if [[ !-d $PROJECT_NAME ]]; then
	git clone https://github.com/lizhenliang/tomcat-java-demo
	cd $PROJECT_NAME
else
	cd $PROJECT_NAME
	git pull
fi
#构建
mvn clean package -Dmaven.test.skip=true
if [[ $? -ne 0 ]]; then
	echo"maven build failure"
	exit 1
fi
#部署
TOMCAT_PID=$(ps -ef |grep "$TOMCAT_NAME" |egrep -v "grep|$$" |awk'NR==1{print $2}')
[ -n "$TOMCAT_PID" ] && kill -9 $TOMCAT_PID
[ -d "$ROOT" ] && mv $ROOT $BACKUP_DIR/${TOMCAT_NAME}_ROOT$DATE
unzip $WORK_DIR/$PROJECT_NAME/target/*.war -d $ROOT
$TOMCAT_DIR/bin/startup.sh
