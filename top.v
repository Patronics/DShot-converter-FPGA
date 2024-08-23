// look in pins.pcf for all the pin names on the TinyFPGA BX board
module top (
    input CLK,    // 16MHz clock
    output LED,   // User/boot LED next to power LED
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

    baudrate16MHz baud5(
        .clk_in(CLK),
        .enable(1),
        .clk_out(clockOut),
        .half_clk_out(halfClockOut),
        .quarter_clk_out(quarterClockOut)
    );

    // keep track of time and location in blink_pattern
    reg [25:0] blink_counter;

    // pattern that will be flashed over the LED over time
    wire [31:0] blink_pattern = 32'b101010001110111011100010101;

    // increment the blink_counter every clock
    always @(posedge CLK) begin
        blink_counter <= blink_counter + 1;
    end
    
    // light up the LED according to the pattern
    assign LED = quarterClockOut;//blink_pattern[blink_counter[25:21]];
    assign PIN_14 = halfClockOut;
    assign PIN_15 = clockOut;
endmodule
