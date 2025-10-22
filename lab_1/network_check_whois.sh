#!/bin/bash
# Skrypt: network_check_whois.sh
# Cel: wykrywa podejrzane połączenia i pokazuje właścicieli IP (whois)

echo "🔍 AKTYWNE POŁĄCZENIA WYCHODZĄCE (netstat)"
echo "=========================="
sudo netstat -tunp | grep ESTABLISHED
#echo ""

echo "=========================="
echo "🌐 PODEJRZANE IP (spoza lokalnej sieci)"
echo "=========================="

# Wydobycie unikalnych IP spoza lokalnych zakresów
# grep -Ev filtruje wybiera adrsy IP nie zaczynające się od 127., 192.168. lub 10.
ip_list=$(sudo netstat -tunp | grep ESTABLISHED | awk '{ print $5 }' | cut -d: -f1 | \
  grep -Ev '^(127\.|192\.168\.|10\.)' | sort | uniq)

for ip in $ip_list; do
  echo "📍 Sprawdzanie IP: $ip"
  # cut -d: -f2- wybiera wszystko po pierwszym dwukropku aż do końca linii
  owner=$(whois $ip | grep -iE 'OrgName|Organization|org-name|descr' | head -n 1 | cut -d: -f2- )
  if [ -z "$owner" ]; then
    owner="(brak informacji o organizacji)"
  fi
  echo "  🏢 Właściciel: $owner"
  echo ""
done
echo "=========================="
echo "📈 MONITORING PASMA (iftop - 10 sekund, naciśnij 'q' by wyjść)"
echo "=========================="
sudo iftop -n -t -s 10

echo "✅ Gotowe."
