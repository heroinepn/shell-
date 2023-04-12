#!/bin/bash
#这是一个curl命令，用于检查指定的URL是否可访问，并返回HTTP状态码。以下是每个参数的解释：
#- '-o /dev/null'将curl的输出重定向到/dev/null，以避免在终端上显示任何信息。
#- '--connect-timeout'参数指定连接超时时间（秒），在此时间内如果无法建立连接，curl就会放弃连接尝试。
#- '-s'参数用于静默操作，即不显示任何进度或错误信息。
#- '-w'参数用于指定一个格式化的输出。完成请求传输后，使 curl 在 stdout 上显示自定义信息
#-w 格式是一个字符串，可以包含纯文本和任意数量的变量，所有变量的格式为：%占位符 %{variable name} '%{(http_code}'是curl内置变量将返回HTTP状态码。
URL_LIST="www,baidu.com www.360.com"
for URL in $URL_LIST; do
	FAIL_COUNT=0
	for((i=1; i<=3;i++));do
		HTTP_CODE=$(curl -o /dev/null --connnect -timeout 3
		 -s -w "%{http_code}" $URL)
		if [[ $HTTP_CODE -eq 200 ]]; then
			echo "$URL ok"
			break
		else
			echo " retry $FAIL_COUNT"
			let FAIL_COUNT++

		fi
done
	if [ $FAIL_COUNT -eq 3 ];then
	echo "warning:$URL Access failure!"
	fi
done
