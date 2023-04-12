#查看CPU $(赋值) ${取值} 可省略{} ;$1 参数 NR行数 NF最后一列

#！/bin/bash
function cpu(){
	util=$(vmstat |awk '{if(NR==3)print $13+$14}')
	iowait=$(vmstat |awk'{if(NR==3)print $16}')
	echo "CPU-使用率: ${util}%, 等待磁盘IO响应使用率：${iowait}%"
}
function memory(){
	total=$(free  -m |awk '{if(NR==2)printf "%.1f" ,$2/1024}')
	used=$(free -m |awk '{if (NR==2)printf "%.1f" ,($2-$NF)/1024}')
	available=$(free -m |awk '{if(NR==2)printf "%.1f" ,$NF/1024}')
	echo "内存-总大小：${total}G,已使用$used,剩余: $available"
}
#获取第一列匹配字符-v  var=value赋值一个用户定义变量。
#p=$p 取for p 遍历的值 重新赋予p
#p=$p 'if($1==p)可以改为if($1==$p)
disk(){
	fs=$(df -h |awk '/^\/dev/{print $1}')
	for p in $fs; do
		mounted=$(df -h |awk -v p=$p 'if($1==p){print $NF}')
		size=$(df -h |awk -v p=$p '$1==p {print $2}')
		used=$(df -h |awk -v p=$p '$1==p {print $3}')
		used_percent=$(df -h |awk -v p=$p '$1==p{print $5}')
		echo "硬盘-挂载点：$mounted,总大小：$size,已使用：$used,使用率：$used_percent"
	done
}
#a=[o,b,c,d]a[0]=o a[0]++
'''
字段值作为数组索引 并将该索引对应的元素值加一
'''
#a[$6] 取出第六列的变量以数组形式存在 每个字段出现的次数累加 i 是遍历了数组中的所有字段 a[i]变量的累加次数值
tcp_status(){
	summary=$(netstat -antp |awk '{a[$6]++}END{for (i in a)printf i,":"a[i] ""}')
	echo " TCP链接状态$summary"  
	
}
cpu
memory
disk
tcp_status