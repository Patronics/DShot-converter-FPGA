module blctrlHandler (
    input wire clk,
    input wire masterEnable=0,
    input wire [0:7] motorEnable= 8'b0,
    input wire [63:0] targetSpeedFlat,  //array of 8 entries of 8-bit target speeds, packed into a 64 bit block as required by older versions of verilog

    input  wire        scl_i,
    output wire        scl_o,
    output wire        scl_t,
    input  wire        sda_i,
    output wire        sda_o,
    output wire        sda_t,
);
    wire [7:0] targetSpeed [0:7];
    assign targetSpeed[0] = targetSpeedFlat[63:56];
    assign targetSpeed[1] = targetSpeedFlat[55:48];
    assign targetSpeed[2] = targetSpeedFlat[47:40];
    assign targetSpeed[3] = targetSpeedFlat[39:32];
    assign targetSpeed[4] = targetSpeedFlat[31:24];
    assign targetSpeed[5] = targetSpeedFlat[23:16];
    assign targetSpeed[6] = targetSpeedFlat[15:8];
    assign targetSpeed[7] = targetSpeedFlat[7:0];
    
    localparam [6:0] baseAddress = 7'h29;
    //localparam [6:0] address [0:7] = {7'h29, 7'h2A, 7'h2B, 7'h2C, 7'h2D, 7'h2E, 7'h2F, 7'h30};   //array of 8 entries of 7-bit i2c addresses
    //note that the motor connected to address 2A is damaged





endmodule