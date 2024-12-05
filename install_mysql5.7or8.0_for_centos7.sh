#!/bin/bash
#
#******************
#auth:songxiaomin
#qq:3242694112
#date:2024-12-04
#******************
#针对的是已经编译好的二进制包
. /etc/init.d/functions #.和source等价，这样可以调用functions文件中的函数和变量
SRC_DIR=`pwd`
MYSQL='mysql-8.0.19-linux-glibc2.12-x86_64.tar.xz' #这是已经下载好的二进制包
COLOR="echo -e  \\033[1;32m"
END="\\033[0m"
MYSQL_ROOT_PASSWORD=Sxm@325468  #数据库初始化密码

check(){
if [ $UID -ne 0 ];then
	action "当前用户不是root，安装失败" false
	exit
fi

cd $SRC_DIR
if [ ! -e $MYSQL ];then
	$COLOR"缺少${MYSQL},安装失败"$END
	$COLOR"请将相关软件放到${SRC_DIR}下再进行安装"$EDN
	exit
elif [ -e /usr/local/mysql ];then
	action "数据库已经存在，安装失败" false
	exit
else
	return
fi
}
install_mysql(){
	$COLOR"开始安装mysql数据库..."$END
	yum -y -q install libaio numactl-libs   #-q：表示 "quiet"（安静模式），减少输出的信息量
	[ $? -ne 0 ] && { $COLOR"libaio numactl-libs安装失败"$EDN ;exit; }
	cd $SRC_DIR
	tar -xJf $MYSQL -C /usr/local/
	MYSQL_DIR=`echo $MYSQL | sed -nr 's/^(.*[0-9]).*/\1/p'`
	ln -s /usr/local/$MYSQL_DIR  /usr/local/mysql
	chown -R root.root /usr/local/msyql
	id mysql &> /dev/null || { useradd -s /sbin/nologin -r mysql ; action "创建mysql用户"; }

	echo 'PATH=/usr/local/mysql/bin/:$PATH' > /etc/profile.d/mysql.sh
	. /etc/profile.d/mysql.sh
	ln -s /usr/local/mysql/bin/*   /usr/bin/
cat > /etc/my.cnf  << EOF
[mysqld]
server-id=1
log-bin
datadir=/data/mysql
socket=/data/mysql/mysql.sock
log-error=/data/mysql/mysql.log
pid-file=/data/mysql/mysql.pid
[client]
socket=/data/mysql/mysql.sock
EOF
        [ -d /data ] || mkdir /data
	mysqld --initialize  --user=mysql  --datadir=/data/mysql #生成数据库随机密码
	#设置开机自启（centos7及以下）
	cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld  
	chkconfig --add mysqld  #将 mysqld 服务添加到系统的启动项中，使得 MySQL 能够在系统启动时自动启动 
	#cp /usr/local/mysql/supporrt-files/mysql.server /etc/init.d/mysqld
	#systemctl enable mysqld （centos7以上的版本)
	service mysqld start
	[ $? -ne 0 ] && { $COLOR"数据库启动失败,退出"$END; exit; }
	sleep 3
	MYSQL_OLDPASSWORD=`awk '/A temporary password/{print $NF}' /data/mysql/mysql.log`
	mysqladmin -uroot -p$MYSQL_OLDPASSWORD password $MYSQL_ROOT_PASSWORD &>/dev/null
	action "数据库安装完成"
}

check
install_mysql






