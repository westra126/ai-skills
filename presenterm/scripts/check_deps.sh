#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ok=0
warn=0
fail=0

check() {
    local name="$1"
    local cmd="$2"
    local install_hint="$3"
    local required="${4:-false}"

    if command -v "$cmd" &>/dev/null; then
        local version
        version=$("$cmd" --version 2>/dev/null | head -1 || echo "unknown")
        printf "${GREEN}[OK]${NC} %-20s %s\n" "$name" "$version"
        ok=$((ok + 1))
    elif [ "$required" = "true" ]; then
        printf "${RED}[MISSING]${NC} %-16s %s\n" "$name" "$install_hint"
        fail=$((fail + 1))
    else
        printf "${YELLOW}[OPTIONAL]${NC} %-14s %s\n" "$name" "$install_hint"
        warn=$((warn + 1))
    fi
}

echo "=== presenterm Dependency Check ==="
echo ""

check "presenterm" "presenterm" "cargo install presenterm" "true"
check "mermaid-cli" "mmdc" "npm install -g @mermaid-js/mermaid-cli" "false"
check "typst" "typst" "https://github.com/typst/typst/releases" "false"
check "pandoc" "pandoc" "apt install pandoc / brew install pandoc" "false"
check "d2" "d2" "curl -fsSL https://d2lang.com/install.sh | sh -s --" "false"
check "node" "node" "https://nodejs.org" "false"

echo ""
echo "--- Summary ---"
printf "${GREEN}OK: %d${NC}  " "$ok"
printf "${YELLOW}Optional missing: %d${NC}  " "$warn"
printf "${RED}Required missing: %d${NC}\n" "$fail"

if [ "$fail" -gt 0 ]; then
    echo ""
    echo "Required dependencies are missing. Install them before proceeding."
    exit 1
fi

if [ "$warn" -gt 0 ]; then
    echo ""
    echo "Some optional tools are missing. Diagrams/formulas using those tools won't render."
    exit 0
fi

echo ""
echo "All dependencies are satisfied!"
exit 0
