#!/bin/bash

katalog="$1"
raport="$2"

znaleziono_plikow=0
usunieto_x_z_plikow=0

echo "nazwa_skryptu,rozmiar,mial_x" > "$raport"

while read -d $'\0' plik; do
    znaleziono_plikow=$((znaleziono_plikow + 1))
    ma_x="nie"

    if [ -x "$plik" ]; then
        ma_x="tak"
        chmod -x "$plik"
        usunieto_x_z_plikow=$((usunieto_x_z_plikow + 1))
    fi
    
    rozmiar=$(du -k "$plik" | cut -f1)
    
    echo "\"$plik\",$rozmiar,$ma_x" >> "$raport"

done < <(find "$katalog" -type f -not -name '*.sh' -print0)

echo "Raport zapisano do pliku $raport."
echo "Znaleziono $znaleziono_plikow plików z rozszerzeniem innym niż .sh."
echo "W $usunieto_x_z_plikow plikach usunięto atrybut wykonywalności x."