#!/bin/bash
# ========================================
# Skrypt: bezpieczna_kopia.sh
# Opis: Kopiuje plik z punktu A do B
# Użycie:
#   ./bezpieczna_kopia.sh <plik_źródłowy> <plik_docelowy>
# Przykład:
#   ./bezpieczna_kopia.sh dane.txt backup.txt
# ========================================
# === Sprawdzenie liczby parametrów ===
if [ $# -ne 2 ]; then
  echo "❌ Błąd: Niepoprawna liczba argumentów."
  echo ""
  echo "Użycie: $0 <plik_źródłowy> <plik_docelowy>"
  echo "Przykład: $0 dane.txt backup.txt"
  exit 1
fi

SRC="$1"
DEST="$2"

# === Sprawdzenie, czy plik źródłowy istnieje ===
if [ ! -f "$SRC" ]; then
  echo "❌ Plik źródłowy '$SRC' nie istnieje!"
  exit 2
fi

# === Próba kopiowania pliku ===
if cp "$SRC" "$DEST"; then
  echo "✅ Plik skopiowano pomyślnie: $SRC → $DEST"
else
  echo "❌ Błąd podczas kopiowania pliku!"
  exit 3
fi
