index_name="logstash-m43-filebeat-nginx-accesslog
            logstash-m44-filebeat-nginx-errorlog"
DAY=(1 2 3)

DATE=`date -d "0 days ago" +%Y.%m.%d`
for i in $index_name;do
    for j in ${DAY[@]};do
       DATE=`date -d "$j days ago" +%Y.%m.%d`
       echo $i-$DATE
       curl -XDELETE http://192.168.75.136:9200/$i-$j
done
#    echo "$i-$DATE"
done
