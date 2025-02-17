#!/bin/bash
#auth:songxiaomin

read -p "plear input year:" year
if [[ ($(expr $year%4) -eq 0 && $(expr $year%100) -ne 0) || $(expr $year%400) -eq 0 ]];then
	echo "$year is leapyear"
else
	echo "$year is not leapyar"
fi
