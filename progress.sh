#!/bin/bash
SLEEP_SECOND=0.5
COUNT=0
while :
do
  # let COUNT++
   case $COUNT in
0)
   echo -n "-"
;;
1)
  echo -n "/"
;;
2)
   echo -ne "*\b"
;;
3)
   echo -ne "/\b"
;;
4)
   echo -n  "#"
   let COUNT=-1
esac
   sleep $SLEEP_SECOND
   let COUNT++
done
