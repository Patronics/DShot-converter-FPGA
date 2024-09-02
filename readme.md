# DShot-Converter-FPGA
For converting DShot RC signals to other formats using TinyFPGA BX or Upduino 3.1

## Currently Implemented Protocols:
- DShot Input
- PWM Output
- I2C Output (compatible with MikroKopter BlCtrl)


## Potentially Planned Simple Additions:
- PPM Output
- OneShot/MultiShot Output

## supported hardware
- Upduino 3.1/3.0
- TinyFPGA BX

## Usage

### dependencies
- [APIO](https://github.com/FPGAwars/apio)

Navigate to the directory corresponding to your hardware (either [tinyFPGA-BX](./tinyFPGA-BX) or [Upduino-3.1](./Upduino-3.1))


to install:
```
make prog
```

to simulate:
```
apio sim -t testbenchFileName_tb.v
```
