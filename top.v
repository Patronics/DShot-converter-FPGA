// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
    input PIN_12,
    input PIN_13,
    output PIN_14,
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
    wire [7:0] targetSpeed2;


    speedhandler speedHandler1(
        .clk(CLK),
        .dshotPin(PIN_13),
        .outputSpeed(targetSpeed1)
    );

    speedhandler speedHandler2(
        .clk(CLK),
        .dshotPin(PIN_12),
        .outputSpeed(targetSpeed2)
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

    //assign targetSpeedFlat[63:56] = targetSpeed1;
    assign targetSpeedFlat[63:56] = targetSpeed1;
    //assign targetSpeedFlat[55:0] = 56'd0;

    assign targetSpeedFlat[55:48] = targetSpeed1;
    assign targetSpeedFlat[47:40] = targetSpeed2;
    assign targetSpeedFlat[39:32] = targetSpeed1;
    assign targetSpeedFlat[31:24] = targetSpeed1;
    assign targetSpeedFlat[23:16] = targetSpeed1;
    assign targetSpeedFlat[15:8] = targetSpeed1;
    assign targetSpeedFlat[7:0] = targetSpeed1;







    blctrlHandler blctrl (
        .clk(CLK),
        .masterEnable(1'b1),
        .motorEnable(8'b11111111), //not currently implemented
        .targetSpeedFlat(targetSpeedFlat),
        .scl_i(scl_i),
        .scl_o(scl_o),
        .scl_t(scl_t),
        .sda_i(sda_i),
        .sda_o(sda_o),
        .sda_t(sda_t)
    );
    //Example of interfacing with tristate pins:
    //may need to adjust according to https://stackoverflow.com/a/37431915/4268196
    SB_IO #(
        .PIN_TYPE(6'b 1010_01),
        .PULLUP(1'b 0)
    ) scl
    (
        .PACKAGE_PIN(PIN_16),
        .OUTPUT_ENABLE(!scl_t),
        .D_OUT_0(scl_o),
        .D_IN_0(scl_i)
    );

    SB_IO #(
        .PIN_TYPE(6'b 1010_01),
        .PULLUP(1'b 0)
    ) sda
    (
        .PACKAGE_PIN(PIN_17),
        .OUTPUT_ENABLE(!sda_t),
        .D_OUT_0(sda_o),
        .D_IN_0(sda_i)
    );
    //assign scl_i = PIN_16;
    //assign PIN_16 = scl_t ? 1'bz : scl_o; //scl_pin
    //assign sda_i = PIN_17;
    //assign PIN_17 = sda_t ? 1'bz : sda_o; //sda_pin



    assign LED = PIN_14;
    //assign PIN_15 = clockOut;

endmodule
