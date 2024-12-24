#!/bin/bash
#date: 2024-12-23

Seconds_Behind_Master(){
   NUM=`mysql -uroot -e "show slave status\G;" | grep "Seconds_Behind_Master:" | awk -F ":" '{print $2}'`
 #  NUM=${ mysql -uroot -e "show slave status\G;" | grep "Seconds_Behind_Masster: " | awk -F : '{print $2}'}
   echo $NUM
}

master_slave_check(){
   NUM1=`mysql -uroot -e "show slave status \G;" | grep "Slave_IO_Runing" | awk -F : '{print $2}'| sed 's/^[\t]*//g'`
   NUM2=`mysql -uroot -e "show slave status \G;" | grep "Slave_SQL_Runing" | awk -F : '{print $2}'| sed 's/^[\t]*//g'`
   
   if test $NUM1 == "Yes" && test $NUM2 == "Yes"; then
#  if [ $NUM1 == "Yes" ] &&  [ NUM2 == "Yes" ];then
       echo 50
   else
       echo 100
fi
main(){
   case $1  in
        Second_Behind_Master)
          Second_Behind_Master 
    ;;
        master_slave_check)
        master_slave_check 
    ;;
   esac
}
    
