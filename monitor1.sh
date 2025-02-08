#!/bin/bash

disk_size=$(df / |awk '/\//{print $4}')
mem_size=$(free |awk '/Mem/{print $4}')

while :
do
	if [ $disk_size -le 1445230000 -o $mem_size -le 131331 ];
	then
		mail -s "Warning" root <<EOF
                "资源有限"
EOF
fi
done
