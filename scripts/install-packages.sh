#!/bin/sh
set -e

wally install
mkdir -p Packages
rojo sourcemap default.project.json -o sourcemap.json
# Only run wally-package-types if Packages/ was created (i.e. there are dependencies)
if [ -d "Packages" ]; then
    wally-package-types --sourcemap sourcemap.json Packages/
fi
