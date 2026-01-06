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
- Other FPGA boards can be supported with corresponding adjustments to the configuration

## Usage

### dependencies
- [APIO](https://github.com/FPGAwars/apio)
- [Nexpnr-ice40 compiled with -DBUILD_GUI=ON](https://github.com/YosysHQ/nextpnr?tab=readme-ov-file#gui) (optional, required for `visualize` command)

For any make command, specify the intended target with 
- `TARGET=upduino` or
- `TARGET=tinyfpga`
- if unspecified, target defaults to `upduino`
- for example: `make build TARGET=tinyfpga`

to install:
```bash
make prog
```

to simulate:
```bash
make sim TB=chosen_testbench_tb.v
```

valid make commands:
- `build` - build for the selected target
- `prog` - build and program the selected target
- `clean` - cleanup build artifacts
- `sim` - simulate the specified testbench
- `test` - run all testbenches (or specific ones with `SB` option) without graphical output
- `visualize` - use nexpnr-ice40 to generate a visualization of the physical layout on the FPGA
- `graph` - create a logical graph of the design
- `report` - create a timing report