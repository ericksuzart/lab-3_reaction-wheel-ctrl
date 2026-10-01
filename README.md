# Controle por Volante de Inércia

Projeto completo de um experimento de controle por volante de inércia (reaction
wheel) desenvolvido na disciplina ENGG54 (LABORATÓRIO INTEGRADO III-A) da UFBA.

O sistema consiste em um motor BLDC gimbal padrão 2805 acoplado a um volante de
inércia, com dois encoders magnéticos **AS5600** para leitura de ângulo (de
forma analógica) e controle realizado por um **ESP32**. O driver de referência é
o [MKS DUAL FOC V3.2](docs/MKS_DUAL_FOC_V3.2.jpg), responsável
pelo controle direto do motor.

## Visão geral do hardware

- **MCU**: ESP32 (esp32dev)
- **Motor**: BLDC gimbal padrão 2805
- **Driver**: MKS DUAL FOC V3.2
- **Encoders**: 2× AS5600 magnéticos, lidos de forma analógica
- **LED de status**: GPIO 2 (padrão)

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

A estrutura física foi modelada no **FreeCAD** (`3d/modelo_3D.FCStd`). As peças
estão disponíveis em `3d/imprimir/peças.3mf`, pronto para impressão 3D.

## Licença

Veja `LICENSE`.
