TARGET ?= upduino

VALID_TARGETS := tinyfpga upduino
ifeq ($(filter $(TARGET), $(VALID_TARGETS)),)
    $(error Unknown target: $(TARGET). Valid targets are: $(VALID_TARGETS))
endif

ifeq ($(TARGET), tinyfpga)
	PROG_CMD = ../venv/bin/tinyprog --pyserial -p hardware.bin
	VISUALIZE_CMD = nextpnr-ice40 --json hardware.json --pcf pins.pcf --asc hardware.asc --lp8k --package cm81 --gui
else ifeq ($(TARGET), upduino)
	PROG_CMD = apio upload --env upduino
	VISUALIZE_CMD = nextpnr-ice40 --json hardware.json --pcf upduino.pcf --asc hardware.asc --up5k --package sg48 --gui
endif

build: *.v
	apio build --env $(TARGET)

prog: build
	$(PROG_CMD)

clean:
	apio clean

sim:
	apio sim --env $(TARGET) $(TB)

visualize: build
	$(VISUALIZE_CMD)

graph:
	apio graph --env $(TARGET)

report:
	apio report --env $(TARGET)

test:
	apio test --env $(TARGET) $(TB)