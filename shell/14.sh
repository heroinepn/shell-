#!/bin/bash
#$1 项目名称
#rsync增量同步-a`：表示以归档模式同步文件`-v`：表示以详细模式输出同步信息。`-z`：表示启用压缩传输，可以加快传输速度
#将指定目录下的项目文件同步到指定的目标目录$WWWROOT中，同时排除 `.git` 目录下的文件和子目录，以保证同步的文件不包含版本控制文件。
DATE=$(date +%F_%T)
WWWROOT=/usr/local/nginx/html/$1
BACKUP_DIR=/data/backup
WORK_DIR=/tmp
PROJECT_NAME=php-demo
#拉取代码
cd $WORK_DIR
if [[ !-d $PROJECT_NAME ]]; then
	git clone https://github.com/lizhenliang/php-demo
	cd $PROJECT_NAME
else 
	cd $PROJECT_NAME
	git pull
fi
#部署
if [[ !-d #WWWROOT ]]; then
	mkdir -p $WWWROOT
	rsync -avz --exclude=.git $WORK_DIR/$PROJECT_NAME/* $WWWROOT
else
	rsync -avz --exclude=.git $WORK_DIR/$PROJECT_NAME/* $WWWROOT
fi