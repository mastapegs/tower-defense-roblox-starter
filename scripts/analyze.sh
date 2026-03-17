#!/bin/sh
set -e

if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

rojo sourcemap default.project.json -o sourcemap.json

curl -fsSL -o globalTypes.d.lua \
    https://raw.githubusercontent.com/JohnnyMorganz/luau-lsp/main/scripts/globalTypes.d.lua

luau-lsp analyze \
    --definitions=globalTypes.d.lua \
    --definitions=testez.d.luau \
    --base-luaurc=src/.luaurc \
    --sourcemap=sourcemap.json \
    --settings=.vscode/settings.json \
    --no-strict-dm-types \
    --ignore="Packages/**" \
    src/
