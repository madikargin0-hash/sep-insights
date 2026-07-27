#!/bin/bash
# Сборка index.html и vault-копии из src/sep-insights.html
cd "$(dirname "$0")"
SRC=src/sep-insights.html
build() { printf '<!doctype html>\n<html lang="ru">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n'; sed -n '1p' "$SRC"; printf '</head>\n<body>\n'; tail -n +2 "$SRC"; printf '\n</body>\n</html>\n'; }
build > index.html
[ -d "$HOME/Documents/nn" ] && build > "$HOME/Documents/nn/Инсайты SEP.html" && echo "vault-копия обновлена"
echo "index.html собран"
