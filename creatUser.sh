#!/bin/bash
read -p "请输入用户名" user
#echo $user
if [ -z  "$user" ];then
	echo "输入的用户名为空，错误退出"
        exit 2
fi

while :
do
	if id "$user" &>/dev/null;then
	  read -p "该用户已经存在,请重新输入"  user
        else
	break
        fi
done

stty -echo  #打开回显，输入的密码不会显示在终端
read -p "请输入密码:" pass
stty echo
pass=${pass:-123456}
useradd $user
echo "$pass" | passwd --stdin $user

