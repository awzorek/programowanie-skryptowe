#!/bin/bash

while read miesiac dzien czas host uzytkownik ip; do
    timestamp="$miesiac $dzien $czas"
    host="${host%:}"
    echo "timestamp<$timestamp>, host:<$host>, user:<$uzytkownik>, adres_ip:<$ip>;"
done < przykladowy_log.log

awk '{print $5}' przykladowy_log.log | sort | uniq -c