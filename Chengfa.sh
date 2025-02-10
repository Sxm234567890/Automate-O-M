#!/bin/bash
for(( i=1;i<=9;i++ ));
do
   for(( j=1;j<=9;j++ ));
do
   printf "%d*%d=%-2d  " $i $j $((i*j))
done
   echo 
done
