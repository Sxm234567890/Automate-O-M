#!/bin/bash
#*****************************
#author: songxiaomin
#qq:     3561694112
#date:   2024-12-2
#*****************************
#一共有16364个槽位
host=$1
port=$2
start=$3
end=$4
pass=123456

for slot in `seq ${start} ${end}` ;do
    echo slot:$slot
    redis-cli -h ${host} -p $port -a ${pass} --no-auth-warning cluster addslots ${slot}
done
