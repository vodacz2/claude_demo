#!/bin/bash

# Skript pro spuštění řešiče matice 2×9

echo "╔════════════════════════════════════════════╗"
echo "║  Řešič matice 2×9 - Prolog CLP(FD)        ║"
echo "╚════════════════════════════════════════════╝"
echo ""

# Kontrola instalace SWI-Prolog
if ! command -v swipl &> /dev/null
then
    echo "CHYBA: SWI-Prolog není nainstalovaný!"
    echo ""
    echo "Instalace:"
    echo "  Ubuntu/Debian: sudo apt-get install swi-prolog"
    echo "  macOS:         brew install swi-prolog"
    echo "  Windows:       https://www.swi-prolog.org/download/stable"
    echo ""
    exit 1
fi

echo "SWI-Prolog nalezen: $(swipl --version | head -n 1)"
echo ""

# Nabídka možností
echo "Vyberte režim:"
echo "  1) Interaktivní režim (zadávání vstupů)"
echo "  2) Spuštění testů"
echo "  3) Prolog konzole (ruční zadávání dotazů)"
echo ""
read -p "Vaše volba [1-3]: " choice

case $choice in
    1)
        echo ""
        echo "Spouštím interaktivní režim..."
        echo ""
        swipl -s matrix_solver.pl -g "run" -t halt
        ;;
    2)
        echo ""
        echo "Spouštím testy..."
        echo ""
        swipl -s test_matrix.pl -t halt
        ;;
    3)
        echo ""
        echo "Spouštím Prolog konzoli..."
        echo "Příkazy:"
        echo "  ?- run.                    % interaktivní režim"
        echo "  ?- example1.               % příklad"
        echo "  ?- run_all_tests.          % spustit testy"
        echo "  ?- halt.                   % ukončit"
        echo ""
        swipl -s matrix_solver.pl
        ;;
    *)
        echo "Neplatná volba!"
        exit 1
        ;;
esac
