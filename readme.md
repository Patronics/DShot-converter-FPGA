# DShot-Converter-FPGA
For converting DShot RC signals to other formats using TinyFPGA BX

## Currently Implemented Protocols:
- DShot Input
- PWM Output

## Planned Protocols:
- I2C Output (compatible with MikroKopter BlCtrl)
- PPM Output

## Usage
to install:
```
make prog
```

to simulate:
```
apio sim -t testbenchFileName_tb.v
```
