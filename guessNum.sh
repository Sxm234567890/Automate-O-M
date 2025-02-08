#!/bin/bash

num=$[RANDOM%100+1]

#echo $num
max=100
min=1
while :
do
   read -p "计算机生成1-100的随机数，你猜是哪个数：" cai
   if [ $cai -lt $num ];
   then
      min=${cai}
      echo "小了重新猜，范围${min}到${max}"
      
   elif [ $cai -gt $num ];
   then
      max=${cai}
      echo "大了重新猜, 范围${min}到${max}"
      
   else
      echo "猜对了，生成的数字是${num}"
      exit
     
   fi
done
