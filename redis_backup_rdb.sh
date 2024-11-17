#!/bin/bash
#************
#author:songxiaomin
#qq:3561694112
#date:2024-11-17
#实现redis的RDB模式
#************
DIR=/apps/redis/data  #rdb数据存储文件在这个路径下
PASS=123456
FILE=dump_6379.rdb
BACKDIR=/back/redis
color(){
  MAL=60
  SET_KONGGE="echo -en \\033[${MAL}G"  #-e是识别转义字符 -n不换行
  SET_SUCCESSCOLOR="echo -en \\033[0;32m"
  SET_FAILCOLOR="echo -en \\033[0;30m"
  SET_WARNINGCOLOR="echo -en \\033[0;33m"
  SET_END="echo -en \\033[0m"
  echo -n  "$1" &&  ${SET_KONGGE}
  echo -n "["
  if [ $2=success -o $2=0 ];then
      ${SET_SUCCESSCOLOR}
      echo -n "success"
  elif [ $2=fail || $2=1 ];then
      ${SET_FAILCOLOR}
      echo -n "fail"
  else
      ${SET_WARNINGCOLOR}
      echo -n "warning"
  fi
  ${SET_END}
  echo -n "]"
  echo 
  
}
#color "damizhenghao" 0
redis-cli -h 127.0.0.1 -a $PASS bgsave
result=`redis-cli -a 123456  info Persistence |grep rdb_bgsave_in_progress | sed -rn 's/.*:([0-9]+).*/\1/p'`    #rdb_bgsave_in_progress=0的时候bgsave执行结束，这时候可以把磁盘上的数据拷到别的主机上
until [ $result=0 ] ; do
   sleep 1
   result=`redis-cli -a 123456  info Persistence| grep rdb_bgsave_in_progress |sed -rn 's/.*:([0-9]).*/\1/p'`#Persistence
done
DATE=`date +%F_%H-%M-%S`
[ -e $BACKDIR ] || { mkdir -p  $BACKDIR ; chown -R redis.redis $BACKDIR; }
mv $DIR/$FILE  $BACKDIR/dump_6379-${DATE}.rdb

color "BACKUP REDIS RDB" 0

