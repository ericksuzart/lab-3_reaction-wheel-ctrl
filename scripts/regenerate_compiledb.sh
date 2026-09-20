#!/bin/sh
# Gera o compile_commands.json para clangd/clang-tidy.
#
# Um `pio run -t compiledb` simples é suficiente para o IntelliSense de src/ e lib/.
# Este wrapper apenas garante que o pio e a toolchain xtensa estejam no PATH,
# para que o clangd resolva o cross-compiler real.
set -e

cd "$(dirname "$0")/.."

# Garante pio e a toolchain xtensa no PATH para o clangd resolver o cross-compiler real
export PATH="$HOME/.platformio/penv/bin:$HOME/.platformio/packages/toolchain-xtensa-esp-elf/bin:$PATH"

echo "==> Gerando compile_commands.json via PlatformIO..."
pio run -t compiledb

echo "==> Pronto. compile_commands.json está atualizado."
