# Controle por Volante de Inércia

Projeto completo de um experimento de controle por volante de inércia (reaction wheel) desenvolvido na disciplina ENGG54 (LABORATÓRIO INTEGRADO III-A) da UFBA: **modelo 3D**, **peças para impressão 3D**, **firmware** e **documentação** de referência.

O sistema consiste em um motor BLDC gimbal padrão 2805 acoplado a um volante de inércia, com dois encoders magnéticos **AS5600** para leitura de ângulo (de forma analógica) e controle realizado por um **ESP32**. O driver de referência é o [MKS DUAL FOC V3.1](docs/Schematic_MKS%20DUAL%20FOC%20V3.1.pdf), responsável pelo controle direto do motor.

## Estrutura do repositório

| Caminho | Descrição |
| --- | --- |
| `3d/` | Modelo 3D do projeto em FreeCAD (`modelo_3D.FCStd`) e montagem pronta para impressão (`.3mf`) |
| `docs/` | Documentação: artigo de referência (Belascuen 2018), esquema do driver MKS DUAL FOC e imagens do AS5600 |
| `src/` | Código-fonte do firmware (ESP-IDF) e configuração de pinos (`Kconfig.projbuild`) |
| `include/`, `lib/`, `components/` | Headers e bibliotecas do firmware (estrutura padrão PlatformIO/ESP-IDF) |
| `.devcontainer/` | Ambiente de desenvolvimento containerizado (Docker + PlatformIO + ESP-IDF) |
| `scripts/` | Scripts auxiliares (ex.: regeneração do `compile_commands.json`) |
| `platformio.ini` | Configuração do projeto PlatformIO (plataforma, ambientes, ferramentas de checagem) |

## Visão geral do hardware

- **MCU**: ESP32 (esp32dev)
- **Motor**: BLDC gimbal padrão 2805
- **Driver**: MKS DUAL FOC V3.1 (esquema em `docs/`)
- **Encoders**: 2× AS5600 magnéticos, lidos de forma analógica
- **LED de status**: GPIO 2 (padrão)

Os pinos de GPIO e periféricos são configurados em `sdkconfig.defaults` e `src/Kconfig.projbuild` (menu *Configuração do Controlador por Volante de Inércia*).

## Configuração do ambiente

1. Abra o VS Code
2. Abra esta pasta
3. Quando solicitado, clique em **"Reopen in Container"** (ou execute `Dev Containers: Rebuild Container` na paleta de comandos)

O container inclui o PlatformIO, a toolchain do ESP-IDF e todas as dependências de build. Nenhuma configuração manual é necessária.

## Firmware

Com o terminal do VS Code (dentro do dev container):

```bash
# Compilar
pio run

# Gravar na placa
pio run -t upload
```

## Modelo 3D

A estrutura física foi modelada no **FreeCAD** (`3d/modelo_3D.FCStd`). As peças estão disponíveis em `3d/imprimir/peças.3mf`, pronto para impressão 3D.

## Licença

Veja `LICENSE`.
