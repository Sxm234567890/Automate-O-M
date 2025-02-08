#!/bin/bash
IP=192.168.75
myping(){
  ping -c 2  -i 0.2  -W 1 $1 &>/dev/null
  if [ $? -eq 0 ];
    then echo "$1 is up"
  else
    echo "$1 is down"
  fi
}
i=1
while [ $i -le 254 ] 
do
    myping $IP.$i &  #多进程
    let i++
done
