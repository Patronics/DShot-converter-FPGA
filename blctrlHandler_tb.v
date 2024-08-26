//`timescale 1us/3125ps
module blctrlHandler_tb;
    

wire [63:0] targetSpeedFlat;
reg clk=0;


wire scl_i;
wire scl_o;
wire scl_t;
wire sda_i;
wire sda_o;
wire sda_t;

wire dummy_scl_i;


reg [7:0] targetSpeed1 = 8'd128;
assign targetSpeedFlat[63:56] = targetSpeed1;
assign targetSpeedFlat[55:48] = targetSpeed1;
assign targetSpeedFlat[47:40] = targetSpeed1;
assign targetSpeedFlat[39:32] = targetSpeed1;
assign targetSpeedFlat[31:24] = targetSpeed1;
assign targetSpeedFlat[23:16] = targetSpeed1;
assign targetSpeedFlat[15:8] = targetSpeed1;
assign targetSpeedFlat[7:0] = targetSpeed1;

blctrlHandler uut (
    .clk(clk),
    .masterEnable(1'b0),
    .motorEnable(8'h0),
    .targetSpeedFlat(targetSpeedFlat),
    .scl_i(scl_i),
    .scl_o(scl_o),
    .scl_t(scl_t),
    .sda_i(sda_i),
    .sda_o(sda_o),
    .sda_t(sda_t)
);

//assign scl_i = scl_o;

// Clock generation
    always begin
        #0.03125 clk = ~clk;  // Toggle clock every time unit


    end

    initial begin
        $dumpfile("blctrlHandler_tb.vcd");
        $dumpvars(3, blctrlHandler_tb, uut);

        #100;
        targetSpeed1 = 8'd133;
        #100000;

        $finish;
    end





endmodule