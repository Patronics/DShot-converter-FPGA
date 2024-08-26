# DShot-Converter-FPGA
For converting DShot RC signals to other formats using TinyFPGA BX

## Currently Implemented Protocols:
- DShot Input
- PWM Output
- I2C Output (compatible with MikroKopter BlCtrl)


## Potentially Planned Protocols:
- PPM Outut

## Usage
to install:
```
make prog
```

to simulate:
```
apio sim -t testbenchFileName_tb.v
```
