module dshotInput(
    input wire clk,
    input wire inPin,
    output wire [10:0] setSpeed,
    output wire armed,
    output wire RCValid,
    output wire processing,
    output wire validSpeed
);


//internal signals
reg reset;
wire inSignal;

synchronizer in_sync (
    .clk(clk),
    .async_in(inPin),
    .sync_out(inSignal)
);

wire clockOut, halfClockOut, quarterClockOut;

baudrate16MHz baudTimer (
        .clk_in(clk),
        .enable(!reset),
        .clk_out(clockOut),
        .half_clk_out(halfClockOut),
        .quarter_clk_out(quarterClockOut)
);

always @(posedge inPin) begin
    if(reset) begin
        reset <= 1'b0; //clear reset
    end
end

//positive edge of quarter clock indicates 
always @(posedge quarterClockOut) begin

end


endmodule