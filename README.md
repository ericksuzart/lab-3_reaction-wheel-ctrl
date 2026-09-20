# Controle por Volante de Inércia — Lab 3 (UFBA)

Projeto completo de um experimento de controle por volante de inércia (reaction wheel) desenvolvido no Lab 3 da UFBA: **modelo 3D**, **peças para impressão 3D**, **firmware** e **documentação** de referência.

O sistema consiste em um motor BLDC gimbal padrão 2805 acoplado a um volante de inércia impresso em 3D, com dois encoders magnéticos **AS5600** para leitura de ângulo (de forma analógica) e controle realizado por um **ESP32** (PlatformIO + ESP-IDF). O driver de referência é o [MKS DUAL FOC V3.1](docs/Schematic_MKS%20DUAL%20FOC%20V3.1.pdf), responsável pelo controle do motor.

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

O container também tem acesso aos dispositivos seriais USB (regras udev já incluídas no Dockerfile), então gravação e monitor serial funcionam sem `--privileged`.

## Firmware

Com o terminal do VS Code (dentro do dev container):

```bash
# Compilar
pio run

# Gravar na placa
pio run -t upload

# Abrir monitor serial (115200 baud)
pio device monitor

# Verificar qualidade do código (clang-tidy + cppcheck)
pio check

# Gerar compile_commands.json para linting/intellisense da IDE
pio run -t compiledb
```

Alternativamente, use `scripts/regenerate_compiledb.sh` para regenerar o `compile_commands.json`.

## Modelo 3D

O mecanismo é modelado em **FreeCAD** (`3d/modelo_3D.FCStd`). A montagem completa está disponível como um único arquivo `.3mf` (`3d/imprimir/peças.3mf`), pronto para impressão 3D.

## Documentação e referências

- `docs/belascuen2018.pdf` — artigo de referência sobre controle por volante de inércia
- `docs/Schematic_MKS DUAL FOC V3.1.pdf` — esquema elétrico do driver de motor
- `docs/as5600_encoder.jpg` e `docs/as5600_dist_to_mag.jpg` — referências de montagem do encoder AS5600 (distância entre o ímã e o chip)

## Licença

Veja `LICENSE`.
