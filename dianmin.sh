#!/bin/bash
FILE=user.txt
if [[ ! -s $FILE ]];then
  echo "点名软件不存在"
  exit
fi
while :
do
   line=$(wc -l < $FILE)
   num=$((RANDOM % $line +1 ))
   name=$(sed -n "${num}p" $FILE)
   clear
   echo -e "\n 随机点到：\033[1;32m$name\033[0m \n"
   sleep 10
done
