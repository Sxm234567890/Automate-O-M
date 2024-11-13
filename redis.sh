#!/bin/bash
#
#**********
#author:  songxiaomin
#date:    2024/11/12
#Filename:redis.sh
#**********
VERSION=redis-4.0.14
PASSWORD=123456
INSTALL_DIR=/apps/redis
color(){
   RES_COL=60
   MOVE_TO_COL="echo -en \\033[${RES_COL}G"
   SETCOLOR_SUCCESS="echo -en \\033[1;32m"
   SETCOLOR_FAILURE="echo -en \\033[1;31m"
   SETCOLOR_WARNING="echo -en \\033[1;33m"
   SETCOLOR_NORMAL="echo -en \E[0m"
   echo -n "$1" && $MOVE_TO_COL
   echo -n "["
   if [ $2 = "success" -o $2 = "0" ];then
      ${SETCOLOR_SUCCESS}
      echo -n $ "ok"                            #echo $ 是直接在屏幕输出$
   elif [ $2 = "failure" -o $2="1" ];then
      ${SETCOLOR_FAILURE}
      echo -n $"FAILED"
   else
      ${SETCOLOR_WARING}
      echo -n $"WARNING"
   fi
   ${SETCOLOR_NORMAL}
   echo -n "]"           #echo -n是抑制换行
   echo
}

#color "redis安装成功" 0
install(){
wget http://download.redis.io/releases/${VERSION}.tar.gz||{ color "Redis源码下载失败" 1;exit; }
yum -y install gcc jemalloc-devel||{ color "安装软件包失败，请检查网络配置" 1;exit; }
   
tar -xf ${VERSION}.tar.gz||{ color "压缩包解压失败" 1;exit;}
cd ${VERSION}                                     #现在是在解压的软件包路径下
make -j 4 PREFIX=${INSTALL_DIR} install && color "redis编译安装完成" 0 || { color "redis编译安装失败" 1;exit;} #-j4是同时运4个作业，加快编译速度（取决于系统资源和项目结构）
 
ln -s ${INSTALL_DIR}/bin/redis-*  /usr/bin/    
mkdir -p ${INSTALL_DIR}/{etc,log,data,run}
cp redis.conf ${INSTALL_DIR}/etc/        
sed -i -e 's/bind 127.0.0.1/bind 0.0.0.0/' -e  "/# requirepass/a requirepass $PASSWORD"  -e  "/^dir .*/c dir ${INSTALL_DIR}/data/" -e "/logfile .*/c logfile ${INSTALL_DIR}/log/redis-6379.log" -e "/logfile .*/c logfile ${INSTALL_DIR}/log/redis_6379.pid"  ${INSTALL_DIR}/etc/redis.conf
#-i是告诉sed直接修改文件内容，-e是后面跟要执行的操作
# c 是替换，a是追加一行 .是单个字符，* 表示跟0个或多个
if id redis &>/dav/null;then
   color "redis用户已经存在"  1
else
   useradd -r -s /sbin/nologin redis #-r是创建系统用户 （系统用户，超级用户，普通用户）
   color "redis用户创建成功"   0
fi

chown -R redis.redis ${INSTALL_DIR}

cat >> /etc/sysctl.conf <<EOF
net.core.somaxconn=1024
vm.overcommit_memory=1
EOF
sysctl -p 
echo 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' >>/etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local
/etc/rc.d/rc.local
cat > /usr/lib/systemd/system/redis.service <<EOF
[Unit]
Description=Redis persistent key-value database
After=network.target
[Service]
ExecStart=${INSTALL_DIR}/bin/redis-server ${INSTALL_DIR}/etc/redis.conf --
supervised=systemd
ExecStop=/bin/kill -s QUIT \$MAINPID
#Type=notify
User=redis
Group=redis
RuntimeDirectory=redis
RuntimeDirectoryMode=0755
[Install]
WantedBy=multi-user.target
EOF
systemctl daemon-reload
systemctl enable --now redis &>/dev/null  && color "redis启动成功,redis信息如下：" 0 ||{color "redis启动失败" 1;exit}
sleep 2
redis-cli -a $PASSWORD INFO Server 2>/dev/null


}
install
