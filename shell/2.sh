#安装邮箱小型发送程序
yum install mail -y
vim /etc/mail.arc
	set from=邮箱地址 smtp=smtp.163.com
	set smtp-auth-user=bb@163.com smtp-auth-passsword=xxxx
	set smtp-auth=login
#测试发送到其他邮箱
#mail -s "邮件主题"  收件人@邮件服务商.com  < 邮件正文内容.txt
echo "test" |mail -s "monitor" pp@163.com
#批量创建用户密码 {批量操作}user{1..10} 设置变量手动传参 $1第一个参数
#--stdin从标准输入中获取密码而不是交互中 给创建好的用户修改密码
#bin/bash
USER_FILE=./user.info
USER_LIST=$1
for USER in USER_LIST; do
	if !id $USER &>/dev/null;then
		PASS=$(echo $RANDOM |md5sum |cut -c 1-8)
		useradd $USER
		echo $PASS |passwd --stdin $USER &>/dev/null
		echo "$USER $PASS " >> $USER_FILE
		echo "$USER User creat sucessful"
	else 
		echo "$USER User already exists"
	fi
done