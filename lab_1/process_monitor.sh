#!/bin/bash

echo "[1] Lista wszystkich procesów (ps aux):"
#   a - pokazuje procesy innych użytkowników
#   u - wyświetla w formacie użytkownika (z nazwą, CPU, RAM)
#   x - pokazuje procesy bez terminala (np. demony)
ps aux | head -10

echo "[2] Przykładowy wynik top (tryb wsadowy):"
#   -b - tryb wsadowy (non-interactive, "batch mode")
#   -n 1 - wykonaj jedno odświeżenie (tylko raz)
top -n 1 -b | head -15

echo "[3] Drzewo procesów (pstree -p):"
#   -p - pokaż PIDy procesów
pstree -p | head -20

echo "[4] Uruchamianie przykładowego procesu w tle (sleep 60)..."
sleep 60 &       # uruchomienie procesu sleep w tle
PID=$!           # $! to PID ostatniego polecenia uruchomionego w tle

echo "Proces sleep uruchomiony z PID: $PID"

echo "[5] Wyszukiwanie procesu sleep po PID:"
# ps:
#   -p - wybierz konkretny PID
#   -o - format wyjścia (tu: pid, command name, elapsed time)
ps -p $PID -o pid,comm,etime

echo "[6] Zabijanie procesu sleep o PID $PID..."
kill $PID        # zakończenie procesu o podanym PID
sleep 1          # krótka pauza na zakończenie

echo "[7] Sprawdzanie, czy proces nadal istnieje:"
if ps -p $PID > /dev/null; then
    echo "❌ Proces nadal działa!"
else
    echo "✅ Proces został zakończony."
fi

