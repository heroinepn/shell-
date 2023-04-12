#!/bin/bash
#yum install inotify-tools
#监控指定目录 `$MON_DIR` 下的文件创建事件，并将创建的文件名及时间记录到日志文件`fil_mon.log` 中，
#-m：表示持续监控模式，即一直监控文件创建事件；
#-q：表示静默模式，不输出监控信息；
#-l`：表示监听符号链接；
#--format %f(MISSING)：表示输出文件名，而不是完整路径名；
#-e create：表示只监控文件创建事件。
#$files` 表示读取到的文件名。
#反斜杠 `\` 是用于转义管道符号 `|`，以避免其被 Shell 解析成管道操作符，而是作为字符串的一部分进行输入传递。
MON_DIR=/opt
inotifywait -mql --format %f -e create $MON_DIR |\
while read files;do
	rsync -avz /opt /tmp/opt
	echo"$(date +'%F_%T') $files" >>fil_mon.log