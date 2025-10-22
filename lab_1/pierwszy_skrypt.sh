#!/bin/bash
#  - "#!/bin/bash" to tzw. shebang – wskazuje, że skrypt ma być uruchomiony przez powłokę Bash (nie np. sh czy dash).
echo "Tworzymy katalog ~/projekt..." # {} to mechanizm grupowania, który pozwala na tworzenie wielu katalogów jednocześnie
mkdir -p ~/projekt/{dokumenty,kopie,raporty}
cd ~/projekt/dokumenty || exit
# - "||" (OR) oznacza: jeśli cd.. się nie powiedzie to "exit" kończy działanie całego skryptu
echo "Raport dzienny 1" > raport1.txt
echo "Raport dzienny 2" > raport2.txt
echo "Raport miesięczny" > raport3.txt
echo "Dokument A" > dokumentA.txt
echo "Dokument B" > dokumentB.txt

echo "Pliki w katalogu dokumenty:"
ls -l
echo "Kopiujemy wszystkie raporty do katalogu kopie..."
cp raport*.txt ../kopie/
echo "Kopiujemy dokumenty do katalogu raporty..."
cp dokument*.txt ../raporty/
cd ~/projekt || exit
echo "Struktura katalogu ~/projekt:"
ls -R # -R pokazuje zawartość katalogów rekurencyjnie
echo "Łączymy raporty w jeden plik zbiorczy..."
cat kopie/raport*.txt > raporty/raport_zbiorczy.txt

# Sprzątanie – usunięcie katalogu projekt
# echo "Sprzątamy katalog ~/projekt..."
# rm -rf ~/projekt

