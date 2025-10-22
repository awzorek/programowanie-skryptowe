#!/bin/bash

INPUT="panTadeusz.txt"

# Liczenie liczby linii, słów i bajtów
echo "1. Statystyka tekstu:" > raport.txt
wc "$INPUT" >> raport.txt
echo >> raport.txt

# Zamiana wszystkich małych liter na wielkie litery
echo "2. Tekst wielkimi literami (pierwsze 10 wierszy):" >> raport.txt
cat "$INPUT" | tr '[:lower:]' '[:upper:]' | head -n 10 >> raport.txt
echo >> raport.txt

# Wyświetlenie tylko unikalnych słów (sort + tr + uniq)
echo "3. Lista unikalnych słów (fragment):" >> raport.txt
cat "$INPUT" \
  | tr '[:space:]' '\n' | tr -d '[:punct:]' | tr 'A-Z' 'a-z' \
  | sort | uniq | head -n 20 >> raport.txt
echo >> raport.txt

# Najczęściej występujące słowa (liczenie, sortowanie malejąco)
echo "4. Najczęstsze słowa (TOP 10):" >> raport.txt
cat "$INPUT" | tr '[:space:]' '\n' | tr -d '[:punct:]' | tr 'A-Z' 'a-z' \
  | sort | uniq -c | sort -nr | head -n 10 >> raport.txt
echo >> raport.txt

# 5. Liczba wystąpień słowa "litwa"
echo "5. Liczba wystąpień słowa 'litwa':" >> raport.txt
# grep -w pozwala znaleźć całe słowa, -o wypisuje każde wystąpienie w nowej linii
cat "$INPUT" | tr 'A-Z' 'a-z' | tr -d '[:punct:]' | grep -wo "litwa" | wc -l >> raport.txt
cat "$INPUT" | tr 'A-Z' 'a-z' | tr -d '[:punct:]' | grep -Ewo "litwa|litwo" | wc -l
echo >> raport.txt

# Ostatnie linie tekstu
echo "6. Ostatnie 5 linijek tekstu:" >> raport.txt
tail -n 5 "$INPUT" >> raport.txt

# Informacja końcowa
echo "Analiza zakończona. Wyniki zapisano do pliku raport.txt."

