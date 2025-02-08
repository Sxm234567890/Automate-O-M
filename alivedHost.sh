#!/bin/bash
IP="192.168.75"
for i in {1..254}
do
   ping -c 2 -i 0.3 -W 1 $IP.$i &>/dev/null #2个ICMP,间隔0.3,1s超时
  if [ $?  -eq 0 ];then
     echo "$IP.$i is alived"
  else
     echo "$IP.$i is not alived"
  fi
done
