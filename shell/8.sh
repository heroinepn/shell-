#!/bin/bash
#$?	显示最后命令的退出状态，0表示没有错误，其他1表示有错误 -ne不等于
#-e选项输出转义字符，比如常用的转义字符“t”，转义字符“t”表示制表符转义字符n换行
#read 内部命令被用来从标准输入读取单行数据后面跟提示信息，即在输入前打印提示信息
#--prefix参数，将要安装的应用安装到指定的目录- 后面一般接缩写，-- 后面一般接全拼，参数是指命令的作用对象
NGINX_V=1.15.6-p 
PHP_V=5.6.36
TMP_DIR=/tmp
INSTALL_DIR=/usr/local
PWD_C=$PWD
echo
echo -e "\tMenu\n"
echo -e "1.Install Nginx"
echo -e "2.Install PHP"
echo -e "4.Deplpoy LNMP"
echo -e "9.Quit"
function command_status_check(){
	if [ $? -ne 0];then
		echo $1
		exit
	fi
}
function install_nginx(){
	cd $TMP_DIR 
	yum install -y gcc gcc-c++ make openssl-devel pcre-devel wget
	wget http://nginx -${NGINX_V}.tar.gz
	tar zxf nginx -${NGINX_V}.tar.gz
	cd nginx -${NGINX_V}
	./configure --prefix=$INSTALL_DIR/nginx \
	--with-http_ssl_module \
	--with-http_stub_status_module \
	--with-stream
	command_status_check "Nginx -平台环境检查失败"
	make -j 4
	command_status_check "Nginx -编译失败" 
	make install
	command_status_check "Nginx -安装失败"
	mkdir -p $INSTALL_DIR/nginx/conf/vhost
	alias cp=cp; cp -rf $PWD_C/nginx.conf $INSTALL_DIR/nginx/conf
	rm -rf $INSTALL_DIR/nginx/html/*
	echo "ok" >$INSTALL_DIR/nginx/html/status.html
	echo '<?php echo "ok" ?>' >$INSTALL_DIR/nginx/html/status.PHP
	$INSTALL_DIR/nginx/sbin/nginx
	command_status_check "Nginx -启动失败"
}
function_install_php(){
	cd $TMP_DIR
	yum install -y gcc -c++ make gd-devel libxml2-devel \
	    libcurl-devel libjpeg-devel libpng-devel openssl-devel \
	    libmcrypt-devel libxslt-devel libtidy-devel
	    wget http://dos.php.net/distributions/php-${PHP_V}.tar.gz
	    tar zxf php-${PHP_V}.tar.gz
	    cd php-${PHP_V}
	    ./configure --prefix=$INSTALL_DIR/php \
	    --with-config-file-path=$INSTALL_DIR/php/etc \
	    --enable-fpm --enable-opcache \
	    --with-mysql --with-mysqli --with-pdo-mysql \
	    --with-openssl --with-zlib --with-curl --with-gd \
	    --with-jpeg-dir --with-png-dir --with-freetype-dir \
	    --enable-mbstring --enable-hash
	    command_status_check "php-平台环境检查失败"
	    make -j 4
	    command_status_check "PHP-编译失败"
	    make install
	    command_status_check "PHP-安装失败"
	    cp php.ini-production $INSTALL_DIR/php/etc/php.ini
	    cp sapi/fpm/php-fpm.conf $INSTALL_DIR/php/etc/php-fpm.conf
	    cp sapi/fpm/init.d.php-fpm /etc/init.d/php-rpm
	    chmod +x /etc/init.d/php-fpm
	    /etc/init.d/php-fpm start
	    command_status_check "PHP-起动失败"
}
read -p "请输入编号：" number
case $number in
	1) install_nginx ;;
	2) install_php ;;
	3) install_mysql ;;
	4) install_nginx install_php ;;
	9) exit;;
esac

