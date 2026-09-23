#!/bin/bash
# Сборка index.html и vault-копии из src/sep-insights.html
cd "$(dirname "$0")"
SRC=src/sep-insights.html
build() { printf '<!doctype html>\n<html lang="ru">\n<head>\n<meta charset="utf-8">\n<meta name="viewport" content="width=device-width, initial-scale=1">\n'; sed -n '1p' "$SRC"; printf '</head>\n<body>\n'; tail -n +2 "$SRC"; printf '\n</body>\n</html>\n'; }
build > index.html
[ -d "$HOME/Documents/nn" ] && build > "$HOME/Documents/nn/Инсайты SEP.html" && echo "vault-копия обновлена"
echo "index.html собран"
# Четвёртая копия — артефакт claude.ai; скрипт её не трогает, сверяется отметка.
python3 - <<'PY'
import json, re, io, os
src = io.open("src/sep-insights.html", encoding="utf-8").read()
m = re.search(r"const DATA = \[(.*?)\n\];", src, re.S)
rec = len(re.findall(r"\{(?:impl|th):", m.group(1))) if m else 0
try:
    st = json.load(io.open(".artifact-sync.json", encoding="utf-8"))["записей"]
except Exception:
    st = None
if st is None:
    print("⚠️  нет отметки .artifact-sync.json — состояние артефакта неизвестно")
elif st != rec:
    print("⚠️  артефакт отстал: в мастере %s записей, опубликовано %s" % (rec, st))
    print("    обновить по процедуре из CLAUDE.md и поправить .artifact-sync.json")
else:
    print("артефакт синхронен: %s записей" % rec)
PY
