#!/bin/bash
#tail -n显示文件的尾部 n 行内容
#grep -c "$IP"`：表示在 `iptables` 防火墙规则中搜索 `$IP`，并统计匹配行数-c：表示只输出匹配行数，不输出匹配内容。
#`$()`：表示命令替换符号，将命令的输出结果作为整体替换到 `$()` 中。
#iptables -vnl` 命令列出当前系统的防火墙规则，然后在规则中搜索 `$IP`，最后判断是否匹配到 `$IP`，如果匹配行数为 0，则表示 `$IP` 不在防火墙规则中。
DATE=$(date +%d/%b/%Y:%H:%M)
LOG_FILE=/usr/local/nginx/logs/demo2.access.log
ABNORAL_IP=$(tail -n5000 $LOG_FILE |grep $DATE |awk '{a[$1]++}END{for (i in a)
	       if (a[i]>100 print i')
for IP  in ABNORAL_IP; do
	if [[ $(iptables -vnl |grep -c"$IP")-eq 0 ]]; then
		iptables -I INPUT -s $IP -j DROP
		echo"$(date +'%F_%T') $IP >> /tmp/drop_ip.log
	fi
done