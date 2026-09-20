#!/bin/sh
set -e

cd "$WORKSPACE_FOLDER"

# Garante que o workspace pertença ao usuário atual (evita problemas de permissão)
sudo chown -R "$(whoami)" "$WORKSPACE_FOLDER"

# Corrige o erro de permissão do first-run-notice do vscode-dev-containers
sudo mkdir -p /home/"$(whoami)"/.config/vscode-dev-containers
sudo chown -R "$(whoami)" /home/"$(whoami)"/.config/vscode-dev-containers

# Recarrega as regras udev (dispositivos USB do PlatformIO)
sudo udevadm control --reload 2>/dev/null || true
