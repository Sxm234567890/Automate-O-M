#!/usr/bin/python3
#执行脚本前要先 yum -y install python3 python3-redis
import redis
from redis.sentinel import Sentinel

sentinel = Sentinel([('192.168.75.136',6379),('192.168.75.133',6379),('192.168.75.135',6379)],socket_timeout=0.5)
redis_authpass="123456"


master = sentinel.discover_master('mymaster')
print(master)

slave = sentinel.discover_slaves('mymaster')
print(slave)

master = sentinel.master_for('mymaster',socket_timeout=0.5,password=redis_authpass,db=0)
w_ret = master.set('name','wang')

slave = sentinel.slave_for('mymaster',socket_timeout=0.5,password=redis_authpass,db=0)
r_ret = slave.get('name')
print(r_ret)
