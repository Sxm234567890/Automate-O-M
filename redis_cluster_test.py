#!/usr/bin/env python3
#install python3 /pip3 install redis-py-cluster before test
from rediscluster import RedisCluster
startup_nodes = [
     {"host":"192.168.75.133","port":6379},
     {"host":"192.168.75.133","port":6380},
     {"host":"192.168.75.136","port":6380},
      {"host":"192.168.75.136","port":6379},
      {"host":"192.168.75.135","port":6380},
      {"host":"192.168.75.135","port":6379},
     ]
     
redis_conn = RedisCluster(startup_nodes=startup_nodes,password='123456',decode_responses=True)

for i in range(0,100):
    redis_conn.set('key'+str(i),'value'+str(i))
    print('key'+str(i)+":",redis_conn.get('key'+str(i)))

    
