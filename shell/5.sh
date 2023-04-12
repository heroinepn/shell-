#!/bin/bash
#-v var=value 变量赋值 print $1取出第一列IP
#在正则表达式中，'^'表示匹配行首，'[^#]'表示不匹配以'#'开头的行
#遍历第一列时，取出IP赋值与ip ，如果ip的值和第一列IP相同输出第二列用户名的值
#int($5)去掉原数据的% 
#总之，awk 'BEGIN{OFS="="}'是一个用于设置输出字段分隔符为等号的awk命令的BEGIN块。
# %=*取值左边 #*=取值右边

#这是一个条件测试语句，用于检查变量$USE_RATE的值是否大于或等于80。并用于确定是否需要发出警告。
#方括号（[]）是条件测试语句的语法结构，在方括号内的表达式被评估为真或假。
#'-ge'是一个比较运算符，表示大于或等于的意思因此，

for IP in $( awk '/^[^#]/ {print $1}'HOST_INFO); do
	USER=$(awk -v ip=$IP 'ip==$1 {print $2}' $HOST_INFO)
	PORT=$(awk -v ip=$IP 'ip==$1 {print $3}' $HOST_INFO)
	TMP_FILE=/tmp/disk.tmp
	ssh -p $POST $USER@$IP 'df-h' >$TMP_FILE
	USE_RATE_LIST=$(awk 'BEGIN{OFS="="}/^\/dev/{print $NF,int($5)}' $TMP_FILE)
	for USE_RATE in USE_RATE_LIST; do
		PART_NAME=${USE_RATE%=*}
		USE_RATE=${USE_RATE#*=}
		if [ $USE_RATE -ge 80 ]; then
			echo "warning: $PART_NAME Partition usage $USE_RATE%!"
			else “all ok"x
		fi
	done
done