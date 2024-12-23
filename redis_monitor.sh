#******
#auth:songxiaomin
#date:2024-12-23
#******

redis_status(){
    PORT=$1
    COMMAND=$2
    PASS=123456
    (echo -en 'info \r\n')|redis-cli -h  127.0.0.1  -p $PORT  -a  $PASS > /tmp/redisinfo.txt 
   # ( echo -en 'info \r\n') | ncat 127.0.0.1 $PORT > /tmp/redisinfo.txt
    out=$(grep "${COMMAND}:" /tmp/redisinfo.txt | cut -d ":" -f2) 
    echo $out
        
}

help(){
   echo "please  $0 redis_status "
}


main(){
  case $1 in
      redis_status)
       redis_status $2 $3
      ;;
      *)
       help
  esac
}

main $1 $2 $3




