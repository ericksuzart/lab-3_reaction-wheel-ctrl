# MKS DUAL FOC V3.2 (Plus) — placa de driver

Documentação de pinout da placa **MKS DUAL FOC V3.2 (Plus)** com módulo
**Lolin32-Lite** (ESP32 rev1). Este componente guarda a definição de todos os
GPIOs da placa em `Kconfig.projbuild`. Os símbolos viram macros do
`sdkconfig.h`:

```c
#include "sdkconfig.h"

gpio_set_level(CONFIG_M0_EN_GPIO, 1);
```

**Pinout igual à Deng FOC 3.0**: a MKS DUAL FOC V3.2 utiliza os mesmos pinouts
que a Deng FOC 3.0. Esquemático de referência:
`components/mks_dual_foc_v32/schematic_deng_foc_3.0.pdf`.

## GPIOs

| GPIO    | Net        | Função                      | ADC           | Observação                                 |
| ------- | ---------- | --------------------------- | ------------- | ------------------------------------------ |
| 32      | M0_IN1     | Motor 0, fase A0 (PWM)      | ADC1_CH4      |                                            |
| 33      | M0_IN2     | Motor 0, fase B0 (PWM)      | ADC1_CH5      |                                            |
| 25      | M0_IN3     | Motor 0, fase C0 (PWM)      | ADC2_CH8      | DAC1                                       |
| 22      | M0_EN      | Enable do driver do Motor 0 |               | pull-down 4.7 kOhm (RN2)                   |
| 26      | M1_IN1     | Motor 1, fase A1 (PWM)      | ADC2_CH9      |                                            |
| 27      | M1_IN2     | Motor 1, fase B1 (PWM)      | ADC2_CH7      | DAC2                                       |
| 14      | M1_IN3     | Motor 1, fase C1 (PWM)      | ADC2_CH6      |                                            |
| 12      | M1_EN      | Enable do driver do Motor 1 | ADC2_CH5      | strapping (MTDI); pull-down 4.7 kOhm (RN2) |
| 36      | M0_OUT1_CS | Corrente da fase A0         | ADC1_CH0      | somente entrada (VP)                       |
| 39      | M0_OUT2_CS | Corrente da fase B0         | ADC1_CH3      | somente entrada (VN)                       |
| 35      | M1_OUT1_CS | Corrente da fase A1         | ADC1_CH7      | somente entrada                            |
| 34      | M1_OUT2_CS | Corrente da fase B1         | ADC1_CH6      | somente entrada                            |
| 19      | SDA_0      | I2C porta 0 (MISO do RFM9x) |               | pull-up 4.7 kOhm (RN1)                     |
| 18      | SCL_0      | I2C porta 0 (CLK do RFM9x)  |               | pull-up 4.7 kOhm (RN1)                     |
| 23      | SDA_1      | I2C porta 1 (MOSI do RFM9x) |               | pull-up 4.7 kOhm (RN1)                     |
| 5       | SCL_1      | I2C porta 1 (SEL do RFM9x)  |               | pull-up 4.7 kOhm (RN1); strapping          |
| 17      | TXD        | UART TX                     |               |                                            |
| 16      | RXD        | UART RX                     |               |                                            |
| 15      | I_0        | Entrada analógica           | ADC2_CH3      | pull-up 4.7 kOhm (RN2); strapping (MTDO)   |
| 13      | I_1        | Entrada analógica           | ADC2_CH4      | pull-up 4.7 kOhm (RN2)                     |
| 0, 2, 4 | —          | Livres (sem net na placa)   | IO2: ADC2_CH2 | IO0 e IO2 são strapping                    |
| 6–11    | —          | Flash SPI interna do ESP32  |               | não utilizáveis                            |

Os sensores de corrente usam shunts de 0.01 Ohm com amplificadores **INA181A2**
(ganho 50).

## Headers

### H1 — header geral (2 x 9 pinos)

| Pino | Sinal | Pino | Sinal |
| ---- | ----- | ---- | ----- |
| 1    | TXD   | 2    | RXD   |
| 3    | GND   | 4    | 3V3   |
| 5    | SDA_0 | 6    | SDA_1 |
| 7    | SCL_0 | 8    | SCL_1 |
| 9    | I_0   | 10   | I_1   |
| 11   | 3V3   | 12   | 3V3   |
| 13   | GND   | 14   | GND   |
| 15   | GND   | 16   | GND   |
| 17   | GND   | 18   | 5V    |

### Outros conectores

| Conector | Função                                                |
| -------- | ----------------------------------------------------- |
| P1       | Fases do Motor 0 (A0/B0/C0 = M0_OUT1/M0_OUT2/M0_OUT3) |
| P2       | Fases do Motor 1 (A1/B1/C1 = M1_OUT1/M1_OUT2/M1_OUT3) |
| P3       | Alimentação VIN (12 ~ 24 V)                           |
| H1       | Header geral                                          |

## Alimentação

- VIN: 12–24 V DC (P3). Abaixo de ~12 V o driver não habilita (ver nota abaixo).
- 5V: conversor TPS54331 (12/24 V → 5 V).
- 3V3: regulador AMS1117-3.3. LED1 indica a saída 3V3 (não é acionável por GPIO).

## Restrições do ESP32 (rev1)

- IO6–IO11: flash SPI interna — não utilizáveis.
- IO34–IO39: somente entrada, sem pull-up interno — já ocupados pelo sensor de
  corrente.
- IO0, IO2, IO5, IO12 e IO15: pinos de strapping — nível errado no reset altera
  o boot. IO15 (I_0) tem pull-up de 4.7 kOhm (RN2), o strapping é seguro a menos
  que uma carga externa puxe a net para baixo no power-up.
- ADC2 (IO2, IO13, IO15): exige firmware sem Wi-Fi nem Bluetooth; com o rádio
  ligado, a leitura falha em ADC2.

## Notas de bancada

- Relatos de uso com firmware MKS indicam que a placa não habilita o driver
  abaixo de ~11.1 V (checagem de sub-tensão com divisor em GPIO 13). O divisor
  não aparece no esquemático; trate o mínimo prático como ~12 V. Fontes:
  [SimpleFOC #8172](https://community.simplefoc.com/t/8172),
  [onedgy.com](https://onedgy.com/blog/waking-a-dead-motor).
