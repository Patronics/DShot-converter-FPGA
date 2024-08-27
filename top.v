// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED

    input PIN_3,  //motor 8
    input PIN_4,  //motor 7
    input PIN_5,  //motor 6
    input PIN_6,  //motor 5

    //pins 7, 8, 9 are unused

    input PIN_10,  //motor 4
    input PIN_11,  //motor 3
    input PIN_12,  //motor 2
    input PIN_13,  //motor 1

    inout PIN_14,  //i2c scl
    inout PIN_15,  //i2c sda

    //pins 16-24 are unused

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
    wire [7:0] targetSpeed3;
    wire [7:0] targetSpeed4;
    wire [7:0] targetSpeed5;
    wire [7:0] targetSpeed6;
    wire [7:0] targetSpeed7;
    wire [7:0] targetSpeed8;

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

    speedhandler speedHandler3(
        .clk(CLK),
        .dshotPin(PIN_11),
        .outputSpeed(targetSpeed3)
    );

    speedhandler speedHandler4(
        .clk(CLK),
        .dshotPin(PIN_10),
        .outputSpeed(targetSpeed4)
    );

    speedhandler speedHandler5(
        .clk(CLK),
        .dshotPin(PIN_6),
        .outputSpeed(targetSpeed5)
    );

    speedhandler speedHandler6(
        .clk(CLK),
        .dshotPin(PIN_5),
        .outputSpeed(targetSpeed6)
    );

    speedhandler speedHandler7(
        .clk(CLK),
        .dshotPin(PIN_4),
        .outputSpeed(targetSpeed7)
    );

    speedhandler speedHandler8(
        .clk(CLK),
        .dshotPin(PIN_3),
        .outputSpeed(targetSpeed8)
    );

    /*pwmout testPwmOut(
        .clk(CLK),
        .enable(1'b1),
        .targetSpeed(targetSpeed1),
        .pwmPin(PIN_14)
    );*/

    //i2c handling:
    wire [63:0] targetSpeedFlat;
    wire scl_i, scl_o, scl_t, sda_i, sda_o, sda_t;

    //assign targetSpeedFlat[63:56] = targetSpeed1;
    assign targetSpeedFlat[63:56] = targetSpeed1;
    //assign targetSpeedFlat[55:0] = 56'd0;

    assign targetSpeedFlat[55:48] = targetSpeed2;
    assign targetSpeedFlat[47:40] = targetSpeed3;
    assign targetSpeedFlat[39:32] = targetSpeed4;
    assign targetSpeedFlat[31:24] = targetSpeed5;
    assign targetSpeedFlat[23:16] = targetSpeed6;
    assign targetSpeedFlat[15:8] = targetSpeed7;
    assign targetSpeedFlat[7:0] = targetSpeed8;







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
        .PACKAGE_PIN(PIN_14),
        .OUTPUT_ENABLE(!scl_t),
        .D_OUT_0(scl_o),
        .D_IN_0(scl_i)
    );

    SB_IO #(
        .PIN_TYPE(6'b 1010_01),
        .PULLUP(1'b 0)
    ) sda
    (
        .PACKAGE_PIN(PIN_15),
        .OUTPUT_ENABLE(!sda_t),
        .D_OUT_0(sda_o),
        .D_IN_0(sda_i)
    );
    //assign scl_i = PIN_16;
    //assign PIN_16 = scl_t ? 1'bz : scl_o; //scl_pin
    //assign sda_i = PIN_17;
    //assign PIN_17 = sda_t ? 1'bz : sda_o; //sda_pin

    assign LED = |targetSpeedFlat; //or reduction, if any bit set, set LED

    //assign LED = PIN_14;
    //assign PIN_15 = clockOut;

endmodule
