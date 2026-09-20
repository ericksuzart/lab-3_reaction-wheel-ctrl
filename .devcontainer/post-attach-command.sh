#!/bin/sh
set -e

cd "$WORKSPACE_FOLDER"

# Recarrega as regras udev (dispositivos USB do PlatformIO) a cada attach
sudo udevadm control --reload 2>/dev/null || true

# Regenera o compile_commands.json para o IntelliSense do clangd.
# Roda a cada attach para que o clangd fique sempre em sincronia com o build atual.
./scripts/regenerate_compiledb.sh || echo "*** compiledb falhou (pode precisar de correção manual)"
