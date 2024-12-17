#!/bin/bash
#auth:songxiaomin
#date:2024-12-17

PASSWORD="Sxm@325468"
IP="192.168.75.%"
binlog_path="/data/mysql/"

# 显示密码以确认
echo "Password: $PASSWORD"

# 停止 slave 进程并删除指定用户
mysql -uroot -p"$PASSWORD" -e "stop slave; reset slave all; drop user 'repluser'@'$IP'"

# 删除 binlog 文件
echo "Deleting binlog files in $binlog_path"
rm -rf ${binlog_path}*

# 重启 mysqld 服务
systemctl restart mysqld

