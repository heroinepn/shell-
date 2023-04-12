#/bin/bash
#设置时区并同步时间
#ln [参数][源文件或目录][目标文件或目录]软连接
#如果系统中没有定时同步时间的任务，则执行后面的代码块。
#crontable -l`：查看当前系统中所有的定时任务
#新的定时任务和原有的定时任务合并成一个任务列表。
#crontable`：将新的任务列表写入到crontab中，即将定时同步时间的任务添加到系统中。
#设置每天凌晨1点定时同步时间分　时　日　月　周　，ntpdate命令从time.window.com获取网络时间，并将其设置为系统时间，并不输出任何信息
#2>&1 的意思是将标准错误输出（stderr）重定向到标准输出（stdout）。其中，2表示标准错误输出，1表示标准输出。重定向操作符>后面没有指定文件名，
#表示将标准错误输出重定向到与标准输出相同的位置，即将错误信息输出到与正常信息相同的地方。
#这样做的目的是将所有输出信息都重定向到同一个文件或管道中，方便查看和处理。
#&m>file 意思是把 标准输出 和 标准错误输出 都重定向到文件file中
#n>&m表示使文件描述符n成为输出文件描述符m的副本。这样做的好处是，有的时候你查找文件的时候很容易产生无用的信息,
#如:2> /dev/null的作用就是不显示标准错误输出；另外当你运行某些命令的时候,出错信息也许很重要,便于你检查是哪出了毛病,如:2>&1
# &> 的意思是将标准输出和标准错误输出都重定向到同一个文件或管道中。
#其中，&表示将输出重定向符号后面的文件名或管道符号视为文件描述符，而不是普通的文件名。重定向操作符>表示将标准输出重定向到指定文件或管道中，
#如果文件或管道不存在，则会创建文件或管道。因此，`&>`表示将标准输出和标准错误输出都重定向到同一个文件或管道中。
#/dev/null是一个文件，这个文件比较特殊，所有传给它的东西它都丢弃掉。当程序在你所指定的时间执行后，系统会发一封邮件给当前的用户，
#显示该程序执行的内容，若是你不希望收到这样的邮件，请在每一行空一格之后加上 > /dev/null 2>&1
#后续添加的 |crontable 的作用是将前面命令的标准输出作为输入传递给 `crontab` 命令，用于添加定时任务。
#`|` 符号表示管道符号，用于连接两个命令，将前一个命令的标准输出作为后一个命令的标准输入设置的同步时间追加到crontab。



ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/location
if ! crontable -l |grep ntpdate &>/dev/null ;
   then (echo "* 1 * * *  ntpdate time.window.com >/dev/null 2>&1";crontable -l)
	 	|crontable 
fi 

#禁用SeLinux sed -i 's/old/new' fill 匹配 SELINUX 新旧文件内容替换
sed -i '/SELINUX/{s/permissive/disabled/}' /etc/selinux/config
#关闭防火墙 
# chkconfig 命令用于检查，设置系统的各种服务。egrep: == grep -E 用于显示文件中符合条件的字符
#这段代码的作用是检测当前系统的发行版版本号，如果是 CentOS 7.x 系列，则停止并禁用防火墙 `firewalld`，如果是 CentOS 6.x 系列，则停止并禁用防火墙 `iptables`。
if egrep "7.[0-9]" /etc/redhat-release &>/dev/null; then 
	systemctl stop firewalld
    systemctl disable firewalld
 elif egrep "6.[0-9]" /etc/redhat-release &>/dev/null;then
 	 service iptables stop
 	 chkconfig iptables off
fi
#显示历史命令的操作时间 %F %T whoami 日期时间用户追加 export 命令用于设置或显示环境变量
if !grep HISTTIMEFORMAT /etc/bashrc; then
	echo 'export HISTTIMEFORMAT="%F %T 'whoami' " ' >> /etc/bashrc
fi
#SSH超时关闭 检测是否设置环境变量超时没有添加值600 ，无操作 10分钟后断开连接
if !grep "TMOUT=600" /etc/profile &>/dev/null; then
	echo"export TMOUT=600" >> /etc/profile
fi
#禁止root远程登录 需要留一个有root权限的用户
sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/ssh_config
#禁止定时任务发送不必要的邮件,收件人为空
sed -i 's/^MAILT0=root/MAILT0=""' /etc/crontab
#设置最大打开文件数 扩展打开的文件的数
#这段代码的作用是向 `/etc/security/limits.conf` 文件追加两行内容，即将所有用户的最大打开文件数限制（nofile）设置为 65535。

#使用 `cat` 命令追加内容到 `/etc/security/limits.conf` 文件，`<<EOR` 表示使用 Here Document 方式输入多行内容，结束符为 `EOR`。
#所有用户的软硬限制（soft）最大打开文件数限制为 65535。
 #`EOR`：Here Document 结束符。
#文件追加两行内容，即将所有用户的最大打开文件数限制（nofile）设置为 65535。
if !grep "* soft nofile 65535" /etc/security/limits.conf &>/dev/null; then
cat >> /etc/secrity/limits.conf <<EOF
	* soft nofile 65535
	* hard nofile 65535
EOF
fi
#系统内核化
cat >> /etc/sysctl.conf << EOF
net.ipv4.tco_syncookies = 1
net.ipv4.tcp_max_tw_buckets =20480
net.ipv4.tcp_max_syn_backlog =20480
net.core.netdev_max_backlog =262144
net.ipv4.tcp_fin_timeout =20
EOF
#减少SWAP的使用 权重值
echo "0" >/proc/sys/vm/swappiness
#安装系统性能分析工具
yum install gcc make autoconf vim sysstat net-tools iostat iftop iotop lrzsz -y
#给脚本加权限 后可以./1.sh 不加 bash 1.sh执行 source ./xx.sh   .xx.sh  当前进程运行
chmod +x 1.sh 
#安装脚本转换工具
yum indtall dos2unix -y
dos2unix 1.sh

