#!/bin/bash
#\"转义双引号防止与 -c "冲突 \r 回车
#$*：所有脚本参数的内容：就是调用调用本bash shell的参数。
#spawn启动指定进程---expect获取指定关键字---send向指定程序发送指定字符---执行完成退出.
#exp_continue  在expect中多次匹配就需要用到
#这段代码将$HOST_INFO文件中的每个IP地址、用户名、端口和密码读取到变量中。然后，使用expect命令远程连接到每个服务器，并在连接后执行给定的命令。
#在expect命令中，首先会检查是否已经连接过该服务器。如果是首次连接，则会提示是否确认连接，需要输入yes或no来确认。
#之后，会检查是否需要输入密码，如果需要则输入密码。最后，会执行给定的命令并退出连接。
#在每个服务器上执行完命令后，输出一个分隔符以便分辨每个服务器的输出结果。
#这段代码用于在多个远程服务器上执行给定的命令，便于批量管理服务器。
#在实际应用中，需要将$HOST_INFO替换为实际的服务器信息文件，以及将$COMMAND替换为实际需要执行的命令。
COMMAND=$*
HOST_INFO=host.info
for IP in $(awk '/^[^#]/ {print $1)' $HOST_INFO); do
	USER=$(awk -v ip=$IP 'ip==$1{print $2}' $HOST_INFO)
	PORT=$(awk -v ip=$IP 'ip==$1{print $3}' $HOST_INFO)
	PASS=$(awk -v ip=$IP 'ip==$1{print $4}' $HOST_INFO)
	expect -c " 
	spawn ssh -p $PORT $USER@$IP
	expect{
		\"(yes/no)\" {send \"yes\r\"; exp_continue}
		\"password:\"{send\"$PASS\r\"; exp_continue}
		\"$USER@*\"{send \"$COMMAND\r exit\r\"; exp_continue}
	}
	"
	echo "------------"
done