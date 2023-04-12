#!/bin/bash
#"--"是一个命令行参数，通常用于告诉命令解释器（shell）后面的参数不再是选项（option），
#而是必须被视为参数（argument）来处理。
#在命令行中使用"--"的目的是为了避免一些特殊字符被解释器误认为是选项，从而导致命令执行错误。
#"--sort=-pcpu的作用是告诉ps命令将输出按照CPU占用率和内存占用率进行降序排序.
#-eo 指定信息输出
echo"--------CPU top 10------"
ps -eo pid,pcpu,pmem,args --sort=-pcpu |head -n 10
echo"--------memory top 10------"
ps -eo pid,pcpu,pmem,args --sort=-pmem |head -n 10
#!/bin/bash
#$0~ 是一个awk语法中的模式匹配操作符，它代表匹配当前行（$0）中是否包含某个字符串
#或正则表达式。在这个例子中，$0~"'$NIC'"表示匹配包含变量$NIC的字符串。
#$1在赋值操作符中的作用就是获取赋值操作符右侧的第一个参数的值，并将它赋给左侧的变量。
#print $1的代表匹配到的行定位第一的字段
#这段代码的作用是：从/proc/net/dev文件中查找包含指定网络接口名（$NIC）的行，然后输出该行的第二列（即旧的输入流量值）。
#$NIC 加双引号是为了在awk命令中解析变量，而单引号是为了保证字符串的完整性，避免在匹配过程中出现语法错误。
#单引号：完全引用 双引号：解释输出
NIC=$1
echo "IN -------Out"
while true:do
	old_IN=$(awk '$0~ "'$NIC'" {print$2}' /proc/net/dev)
	old_OUT=$(awk '$0~ "'$NIC'" {print$10}' /proc/net/dev)
	sleep 1
	new_IN=$(awk '$0~"'$NIC'" {print$2}'/proc/net/dev)
	new_OUT=$(awk '$0~"'$NIC'" {print$10}'/proc/net/dev)
	IN=$(printf "%.1f%s" "$((($new_IN-$old_IN)/1024))" "KB/s")
	OUT=$(prints "%.1f%s" "$((($new_OUT=$old_OUT)/1024))" "KB/s")
	echo "$IN $OUT"
	sleep 1
done