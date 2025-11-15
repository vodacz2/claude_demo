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
echo "  1) Interaktivní menu (doporučeno) - vyberte z validních kombinací"
echo "  2) Manuální vstup - zadejte vlastní součty"
echo "  3) Objevit validní kombinace (může trvat několik minut)"
echo "  4) Spuštění testů"
echo "  5) Prolog konzole (ruční zadávání dotazů)"
echo ""
read -p "Vaše volba [1-5]: " choice

case $choice in
    1)
        echo ""
        echo "Spouštím interaktivní menu..."
        echo ""
        swipl -s matrix_solver_interactive.pl -g "main" -t halt
        ;;
    2)
        echo ""
        echo "Spouštím režim s manuálním vstupem..."
        echo ""
        swipl -s matrix_solver.pl -g "run" -t halt
        ;;
    3)
        echo ""
        echo "Spouštím objevování validních kombinací..."
        echo ""
        swipl -s discover_valid_combinations.pl
        ;;
    4)
        echo ""
        echo "Spouštím testy..."
        echo ""
        swipl -s test_matrix.pl -t halt
        ;;
    5)
        echo ""
        echo "Spouštím Prolog konzoli..."
        echo "Příkazy:"
        echo "  ?- main.                   % hlavní menu"
        echo "  ?- run_interactive.        % interaktivní menu"
        echo "  ?- run.                    % manuální vstup"
        echo "  ?- halt.                   % ukončit"
        echo ""
        swipl -s matrix_solver_interactive.pl
        ;;
    *)
        echo "Neplatná volba!"
        exit 1
        ;;
esac
