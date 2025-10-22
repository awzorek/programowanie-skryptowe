#!/bin/bash

TIMESTAMP=$(date "+%a %Y-%m-%d %H:%M:%S")
CPU_LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | xargs)
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
USERS=$(who | awk '{print $1}' | sort | uniq | tr '\n' ';')
TOP_PROC=$(ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6 | tail -n 5 | awk '{print $2"("$3"%)"}' | tr '\n' ';')

echo "TIMESTAMP,CPU_LOAD,MEM_USED,MEM_FREE,USERS,TOP_PROC" >  raport_systemowy.csv
echo "$TIMESTAMP,$CPU_LOAD,$MEM_USED,$MEM_FREE,$USERS,$TOP_PROC" >> raport_systemowy.csv