#author:songxiaomin
#Date:2024-12-24
#**********
#!/bin/bash
nginx_status_fun(){
   NGINX_PORT=$1
   NGINX_COMMAND=$2
   nginx_active(){
    #echo -n "nginx_active "
    /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null |grep  'Active'|awk '{print $NF}'
   }
   nginx_reading(){
   # echo -n "nginx_reading "
   /usr/bin/curl "http://127.0.0.1:${NGINX_PORT}/nginx_status/" 2>/dev/null | grep 'Reading' |awk  '{print $2}'
}
   nginx_writing(){
   # echo -n "nginx_writing "
   /usr/bin/curl "http://127.0.0.1:${NGINX_PORT}/nginx_status/" 2>/dev/null | grep 'Writing' |awk '{print $4}'
}
   nginx_wating(){
  # echo -n "nginx_wating "
   /usr/bin/curl "http://127.0.0.1:"$NGINX_PROT"/nginx_status/"  2>/dev/null | grep 'Waiting' |awk '{print $6}'
}
   nginx_accepts(){
   /usr/bin/curl "http://127.0.0.1:${NGINX_PROT}/nginx_status/" 2>/dev/null | awk NR==3 | awk '{print $1}'
   }  
   nginx_handleds(){
   /usr/bin/curl "http://127.0.0.1:${NGINX_PROT}/nginx_status/" 2>/dev/null | awk NR=3 | awk '{print $2}'
   }
   nginx_requests(){
  /usr/bin/curl "http://127.0.0.1:${NGINX_PROT}/nginx_status/" 2>/dev/null | awk NR=3 |awk '{print $3}'
}
  case $2 in 
    nginx_reading)
      nginx_reading
  ;;
    nginx_writing)
      nginx_writing
  ;;
    nginx_wating)
      nginx_wating
  ;;
    nginx_accepts)
      nginx_accepts
  ;;
    nginx_handleds)
     nginx_handleds
  ;;
     nginx_requests)
      nginx_requests
   ;;
  esac
}
#nginx_status_fun 80 10
main(){
   case $1 in 
     nginx_status_fun)
      nginx_status_fun $2 $3
    ;;
     *)
      echo " usage:${0}+nginx_status_fun 80/443+statu_name"
    ;;
     esac
}
main $1 $2 $3
