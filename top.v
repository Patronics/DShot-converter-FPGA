// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    input PIN_13,
    output PIN_14,
    output PIN_15,
    inout PIN_16,
    inout PIN_17,

    output USBPU  // USB pull-up resistor
);

    wire clockOut;
    wire halfClockOut;
    wire quarterClockOut;


    // drive USB pull-up resistor to '0' to disable USB
    assign USBPU = 0;

    ////////
    // make a simple blink circuit
    ////////

    /*baudrate16MHz #(
        .BAUD(150000)
        ) baudTest(
        .clk_in(CLK),
        .enable(1'b1),
        .clk_out(clockOut),
        .half_clk_out(PIN_15),
        .quarter_clk_out(quarterClockOut)
    );*/

    wire [7:0] speed1;
    /*speedhandler dshot1(
        .clk(CLK),
        .dshotPin(PIN_13),
        .outputSpeed(speed1)
    );*/
    wire pwmOut1Pin;
    wire [7:0] targetSpeed1;

    speedhandler speedHandler1(
        .clk(CLK),
        .dshotPin(PIN_13),
        .outputSpeed(targetSpeed1)
    );

    pwmout testPwmOut(
        .clk(CLK),
        .enable(1'b1),
        .targetSpeed(targetSpeed1),
        .pwmPin(PIN_14)
    );

    //i2c handling:
    wire [63:0] targetSpeedFlat;
    wire scl_i, scl_o, scl_t, sda_i, sda_o, sda_t;
    tri scl_pin, sda_pin;
    assign targetSpeedFlat[63:56] = targetSpeed1;

    blctrlHandler blctrl (
        .clk(CLK),
        .masterEnable(1'b1),
        .motorEnable(8'b10000000),
        .scl_i(scl_i),
        .scl_o(scl_o),
        .scl_t(scl_t),
        .sda_i(sda_i),
        .sda_o(sda_o),
        .sda_t(sda_t),
    );
    //Example of interfacing with tristate pins:
    //may need to adjust according to https://stackoverflow.com/a/37431915/4268196
    assign scl_i = scl_pin;
    assign scl_pin = scl_t ? 1'bz : scl_o;
    assign sda_i = sda_pin;
    assign sda_pin = sda_t ? 1'bz : sda_o;

    assign PIN_16 = scl_pin;
    assign PIN_17 = sda_pin;


    // light up the LED according to the pattern
    assign LED = PIN_14;//blink_pattern[blink_counter[25:21]];
    //assign PIN_15 = clockOut;

endmodule
