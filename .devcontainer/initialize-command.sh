#!/bin/sh
set -e

# Garante que os diretórios de bind-mount do host existam antes do container iniciar
mkdir -p "$HOME/.ssh"
