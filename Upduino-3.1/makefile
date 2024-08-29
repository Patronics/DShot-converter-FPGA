

build: *.v
	apio build

prog: build
	../venv/bin/tinyprog --pyserial -p hardware.bin

clean:
	apio clean

sim:
	apio sim
#todo improve sim target, allow specifing which testbench to use with -t option

visualize: build
	nextpnr-ice40 --json hardware.json --pcf pins.pcf --asc hardware.asc --up5k --package sg48 --gui
