#!/bin/bash
NUM=10
PASS=325468
for i in `seq $NUM`;do
    #redis-cli -h 127.0.0.1 -p 6379 -a "$PASS" --no-auth-passwdset key${i} value${i}
    redis-cli -h 127.0.0.1 -p 6379  -a "$PASS"  set key${i} value${i}
    echo "key${i} value${i} 写入完成"
done
echo "$NUM个key写入完成"
