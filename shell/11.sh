#!bin/bash
#awk End是一种awk命令的用法，用于在awk处理完输入文件中的所有行后执行一些操作。
#以空格符来分割列数 nr 倒叙 k2第二列
#日志格式：
LOG_FILE=$1
echo "统计访问最多的10个IP"
awk '{a[$1]++}END{print "uv:",length(a);for(v in a)print a[v],v}' 
$LOG_FILE |sort -k2 -nr |head -10
echo".............."
echo"统计时间段访问最多的IP"
awk '$4>="[xxx" && $4<="[xxx"{a[$1]++}END{for (v in a);print v,a[v]' 
$LOG_FILE |sort -k2 -nr |head -10
echo".............."
echo "统计访问最多的10个页面"
awk '{a[$7]++}END{print "PV",length(a);for(v in a){if(a[v]>10)print v,a[v]}}'
$LOG_FILE |sort -k2 -nr |head -10
echo".............."
echo "统计访问页面状态码数量"
awk '{a[$7""$9]++}END{for(v in a)if(a[v]>5)print v,a[v]}}'
$LOG_FILE |sort -k3 -nr |head -10
echo".............."
