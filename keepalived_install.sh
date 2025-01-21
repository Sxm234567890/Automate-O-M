#!/bin/bash
#****
#author:songxiaomin
#date:2025-01-21
#****
#安装keepalived 记得keepalived还没配置好的时候是无法启动的 安装好后可以直接去/etc/keepalived/下改配置文件
URL="https://keepalived.org/software/keepalived-2.0.20.tar.gz"
KEEPALIVED_FILE="keepalived-2.0.20.tar.gz"
KEEPALIVED_DIR="/usr/local/"
color(){
   MOVE_KONGGE=60
   SETKONGGE="echo -en \\033[${MOVE_KONGGE}G"
   SETCOLOR_SUCCESS="echo -en \\033[1;31m"
   SETCOLOR_FAIL="echo -en \\033[1;32m"
   SETCOLOR_WARNING="echo -en \\033[1;31m"
   SETCOLOR_END="echo -en \\E[0m"
   echo -n $2 && $SETKONGGE
   echo -n "["
   if [ $1 = "success" -o $1 = "0" ]; then
      $SETCOLOR_SUCCESS
      echo -n "success"
   elif [ $1 = "fail" -o $1 = "1" ]; then
     $SETCOLOR_FAIL
      echo -n "fail"
   else
     $SETCOLOR_WARING
      echo -n "warning"
   fi
     $SETCOLOR_END
    echo -n "]"
    echo
   
}
yum -y install gcc curl openssl-devel libnl3-devel net-snmp-devel
#wget $URL                #-P  ${KEEPALIVED_DIR}
#cd ${KEEPALIVED_DIR}
[ -d ${KEEPALIVED_DIR}/keeplived ] && { corlor 1 "keeplived已经安装" ; exit;  } 
wget $URL
tar -xvf  ${KEEPALIVED_FILE}  -C $KEEPALIVED_DIR
cd $KEEPALIVED_DIR/keepalived-2.0.20/
./configure --prefix=${KEEPALIVED_DIR}/keepalived
make && make install
cat > /usr/lib/systemd/system/keepalived.service << EOF
[Unit]
Description=LVS and VRRP High Availability Monitor
After=network-online.target syslog.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/run/keepalived.pid
KillMode=process
EnvironmentFile=-/usr/local/keepalived/etc/sysconfig/keepalived
ExecStart=/usr/local/keepalived/sbin/keepalived $KEEPALIVED_OPTIONS
ExecReload=/bin/kill -HUP $MAINPID
[Install]
WantedBy=multi-user.targetEOF
EOF

systemctl daemon-reload
#systemctl enable --now keepalived &> /dev/null
#systemctl is-active keepalived &>/dev/null && color 0 "keepalived安装成功" || color 1 "keepalived安装失败"
mkdir /etc/keepalived
cp  $KEEPALIVED/keepalived/etc/keepalived/keepalived.conf /etc/keepalived/keepalived.conf
