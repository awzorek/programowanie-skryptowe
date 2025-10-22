#!/bin/bash

# 1. Uptime i load average
echo "⏱️  [1] Czas działania i obciążenie:"
LOAD=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | xargs)
# xargs usuwa białe znaki z początku i końca
echo "  Load average (1 min): $LOAD"
LOAD_INT=$(echo $LOAD | cut -d'.' -f1)
if [ "$LOAD_INT" -ge 2 ]; then
  echo "  ⚠️  Ostrzeżenie: Wysokie obciążenie systemu!"
fi
echo ""

# 2. Pamięć RAM
echo "💾 [2] Pamięć RAM (free -h):"
FREE_RAM=$(free -m | awk '/^Mem:/ { print $7 }')  # Dostępna pamięć w MB
echo "  Dostępna pamięć: ${FREE_RAM} MB"
if [ "$FREE_RAM" -lt 500 ]; then
  echo "  ⚠️  Ostrzeżenie: Mało dostępnej pamięci RAM!"
fi
echo ""

# 3. Zajętość dysków
echo "📂 [3] Zajętość dysków (df -h):"
df -h | awk 'NR==1 || $5 + 0 >= 40 { print }'  # tylko te z użyciem >=40%
echo ""

# 4. Rozmiar katalogu logów
DIR="/var/log"
echo "📁 [4] Rozmiar katalogu $DIR:"
sudo du -sh "$DIR"
echo ""

#ls /nieistnieje
#echo "Kod wyjścia: $?"
