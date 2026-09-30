# MKS DUAL FOC V3.2 (Plus) — placa de driver

Documentação de pinout da placa **MKS DUAL FOC V3.2 (Plus)** com módulo
**Lolin32-Lite** (ESP32 rev1). Este componente guarda a definição de todos os
GPIOs da placa em `Kconfig.projbuild` (símbolos `CONFIG_<NET>_GPIO`, com
`default` = pino real); a configuração do experimento
(LED e encoders) fica em `src/Kconfig.projbuild`.

Os símbolos viram macros do `sdkconfig.h` e aparecem no menuconfig em
*MKS DUAL FOC V3.2 (pinout da placa)*:

```c
#include "sdkconfig.h"

gpio_set_level(CONFIG_M0_EN_GPIO, 1);
```

A V3.2 (Plus) segue o netlist do esquemático V3.1 para o módulo ESP32.

**Pinout igual à Deng FOC 3.0**: a MKS DUAL FOC V3.2 utiliza os mesmos pinouts
que a Deng FOC 3.0. Esquemático de referência:
`components/mks_dual_foc_v32/schematic_deng_foc_3.0.pdf`.

**Fonte de verdade dos GPIOs**: `docs/Schematic_MKS DUAL FOC V3.1.pdf` —
netlist do módulo U2 (GPIO ↔ net), drivers L6234, amplificadores INA181A2,
redes de pull-up/down e headers.

Documentação de apoio (revisões vizinhas — não substituem o esquemático):

- `docs/MKS-DUALFOC/V3.2/images/pinout.jpg` — silk do header da V3.2;
- `docs/MKS-DUALFOC/Hardware/MKS DUAL FOC V3.3 PLUS_001 SCH.pdf` — headers
  J1/NC1 (a ordem de pinos do header H1 difere da V3.1 — ver abaixo);
- `docs/MKS-DUALFOC/README.md` — mapa de pinos verificado na V3.2.

## GPIOs

| GPIO | Net | Função | ADC | Observação |
|------|-----|--------|-----|------------|
| 32 | M0_IN1 | Motor 0, fase A0 (PWM) | ADC1_CH4 | |
| 33 | M0_IN2 | Motor 0, fase B0 (PWM) | ADC1_CH5 | |
| 25 | M0_IN3 | Motor 0, fase C0 (PWM) | ADC2_CH8 | também DAC1 |
| 22 | M0_EN | Enable do driver do Motor 0 | | LED onboard do Lolin32-Lite; pull-down 4.7 kOhm (RN2) |
| 26 | M1_IN1 | Motor 1, fase A1 (PWM) | ADC2_CH9 | |
| 27 | M1_IN2 | Motor 1, fase B1 (PWM) | ADC2_CH7 | também DAC2 |
| 14 | M1_IN3 | Motor 1, fase C1 (PWM) | ADC2_CH6 | |
| 12 | M1_EN | Enable do driver do Motor 1 | ADC2_CH5 | strapping (MTDI); pull-down 4.7 kOhm (RN2) |
| 36 | M0_OUT1_CS | Corrente da fase A0 | ADC1_CH0 | somente entrada (VP) |
| 39 | M0_OUT2_CS | Corrente da fase B0 | ADC1_CH3 | somente entrada (VN) |
| 35 | M1_OUT1_CS | Corrente da fase A1 | ADC1_CH7 | somente entrada |
| 34 | M1_OUT2_CS | Corrente da fase B1 | ADC1_CH6 | somente entrada |
| 19 | SDA_0 | I2C porta 0 (MISO do RFM9x) | | pull-up 4.7 kOhm (RN1) |
| 18 | SCL_0 | I2C porta 0 (CLK do RFM9x) | | pull-up 4.7 kOhm (RN1) |
| 23 | SDA_1 | I2C porta 1 (MOSI do RFM9x) | | pull-up 4.7 kOhm (RN1) |
| 5 | SCL_1 | I2C porta 1 (SEL do RFM9x) | | pull-up 4.7 kOhm (RN1); strapping |
| 17 | TXD | UART TX do header | | |
| 16 | RXD | UART RX do header | | |
| 15 | I_0 | Entrada analógica do header | ADC2_CH3 | pull-up 4.7 kOhm (RN2); strapping (MTDO) |
| 13 | I_1 | Entrada analógica do header | ADC2_CH4 | pull-up 4.7 kOhm (RN2) |
| 0, 2, 4 | — | Livres (sem net na placa) | IO2: ADC2_CH2 | IO0 e IO2 são strapping |
| 6–11 | — | Flash SPI interna do módulo | | não utilizáveis |

Os sensores de corrente usam shunts de 0.01 Ohm com amplificadores **INA181A2**
(ganho 50). Os exemplos oficiais leem o Motor 0 nos pinos (39, 36) e o Motor 1
nos pinos (35, 34) — ver `docs/MKS-DUALFOC/Test Code`.

## Headers

### H1 — header geral (2 x 9 pinos)

Ordem do esquemático V3.1 (fonte de verdade):

| Pino | Sinal | Pino | Sinal |
|------|-------|------|-------|
| 1 | TXD | 2 | RXD |
| 3 | GND | 4 | 3V3 |
| 5 | — | 6 | — |
| 7 | SDA_0 | 8 | SDA_1 |
| 9 | SCL_0 | 10 | SCL_1 |
| 11 | I_0 | 12 | I_1 |
| 13 | GND | 14 | GND |
| 15 | GND | 16 | GND |
| 17 | GND | 18 | 5V |

Notas:

- Os pinos 5 e 6 saem sem net no esquemático (stubs abertos).
- Nos pinos 11/12 o desenho sobrepõe um símbolo VCC-3.3V aos labels I_0/I_1.
  As nets I_0/I_1 são as entradas analógicas do módulo (GPIO15/GPIO13) e têm
  pull-up próprio no RN2; trate os pinos 11/12 como I_0/I_1 e confirme com
  multímetro antes do primeiro uso.
- Revisões vizinhas mudam esta ordem: o silk da V3.2 e o esquemático V3.3 PLUS
  trazem SDA_0/SDA_1 nos pinos 5/6, SCL_0/SCL_1 nos 7/8, I_0/I_1 nos 9/10 e
  3V3 nos 11/12.

### Outros conectores

| Conector | Função |
|----------|--------|
| P1 | Fases do Motor 0 (A0/B0/C0 = M0_OUT1/M0_OUT2/M0_OUT3) |
| P2 | Fases do Motor 1 (A1/B1/C1 = M1_OUT1/M1_OUT2/M1_OUT3) |
| P3 | Alimentação VIN |
| H1 | Header geral (tabela acima) |

## Alimentação

- VIN: 12–24 V DC (P3). Abaixo de ~12 V o driver não habilita (ver nota abaixo).
- 5V: conversor TPS54331 (12/24 V → 5 V).
- 3V3: regulador AMS1117-3.3. LED1 indica a saída 3V3 (não é acionável por GPIO).

## Restrições do ESP32 (rev1)

- IO6–IO11: flash SPI interna — não utilizáveis.
- IO34–IO39: somente entrada, sem pull-up interno — já ocupados pelo sensor de
  corrente.
- IO0, IO2, IO5, IO12 e IO15: pinos de strapping — nível errado no reset altera
  o boot. IO15 (I_0) tem pull-up de 4.7 kOhm (RN2), então o strapping é seguro
  a menos que uma carga externa puxe a net para baixo no power-up.
- ADC2 (IO2, IO13, IO15): exige firmware sem Wi-Fi nem Bluetooth em nenhum
  caminho de código; com o rádio ligado, `adc_oneshot_read()` falha em ADC2.

## Notas de bancada

- Relatos de uso com firmware MKS indicam que a placa não habilita o driver
  abaixo de ~11.1 V (checagem de sub-tensão com divisor em GPIO 13). O divisor
  não aparece no esquemático V3.1; trate o mínimo prático como ~12 V.
  Fontes: [SimpleFOC #8172](https://community.simplefoc.com/t/8172),
  [onedgy.com](https://onedgy.com/blog/waking-a-dead-motor).
- O pino de enable do Motor 0 (IO22) é o LED onboard do Lolin32-Lite: o LED
  pisca junto com o enable do driver e não pode ser usado como LED de status.
