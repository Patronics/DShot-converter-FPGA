

build: *.v
	../venv/bin/apio build

prog: build
	../venv/bin/tinyprog --pyserial -p hardware.bin

clean:
	../venv/bin/apio clean

sim:
	../venv/bin/apio sim
#todo improve sim target, allow specifing which testbench to use with -t option
