// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    input PIN_13,
    output PIN_14,
    output PIN_15,
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

   /* baudrate16MHz baud5(
        .clk_in(CLK),
        .enable(1'b1),
        .clk_out(clockOut),
        .half_clk_out(halfClockOut),
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




    // light up the LED according to the pattern
    assign LED = PIN_14;//blink_pattern[blink_counter[25:21]];
    //assign PIN_15 = clockOut;

endmodule
