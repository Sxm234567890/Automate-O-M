#!/bin/bash
gitlab-ctl stop
rpm -e gitlab-ce
ps aux | grep gitlab|grep runsvdir > dami.txt
`awk -F " " '{print $2}' dami.txt`|xargs kill -9
rm -f dami.txt
find / -name gitlab | xargs rm -rf
rm -rf  /opt/gitlab &>/dev/null     #后面这三个是怕前面没有被删除干净
rm -rf  /etc/gitlab &>/dev/null
rm -rf  /var/log/gitlab &>/dev/null





