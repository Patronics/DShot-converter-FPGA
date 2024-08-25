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
    //note that the motor connected to address 2A is damaged

    reg [2:0] currentOutputCounter = 3'b0;
    wire [6:0] currentAddress;
    wire [6:0] sentAddress;
    wire [7:0] currentTargetSpeed;
    assign currentAddress = baseAddress + currentOutputCounter;
    assign currentTargetSpeed = targetSpeed[currentOutputCounter];

    wire cmd_start = 0;  //set start to force generation of a start condition, start is implied when bus is inactive or active with read or different address
    wire cmd_read = 0; //not yet used
    wire cmd_write;
    wire cmd_write_multiple;
    wire cmd_stop = 1;   //    set stop to issue a stop condition after writing current byte
    wire cmd_valid;
    wire cmd_ready;
    wire cmd_write_multiple = 0;
    wire cmd_stop;
    wire cmd_valid;
    wire cmd_ready;

    //s_axis_data_tdata is currentTargetSpeed
    wire valid_output;
    wire target_ready;
    wire target_last;

    wire [7:0] incoming_i2c_data;
    wire incoming_data_valid;
    wire ready_for_incoming_data;
    wire incoming_data_last;

    wire module_busy;
    wire module_in_control_of_bus;
    wire bus_busy;
    wire missed_ack;


    i2c_master i2cOut (
        .clk(clk),
        .rst(1'b0),
        .s_axis_cmd_address(currentAddress),
        .s_axis_cmd_start(cmd_start),
        .s_axis_cmd_read(cmd_read),
        .s_axis_cmd_write(cmd_write),
        .s_axis_cmd_write_multiple(cmd_write_multiple),
        .s_axis_cmd_stop(cmd_stop),
        .s_axis_cmd_valid(cmd_valid),
        .s_axis_cmd_ready(cmd_ready),

        .s_axis_data_tdata(currentTargetSpeed),
        .s_axis_data_tvalid(valid_output),
        .s_axis_data_tready(target_ready),
        .s_axis_data_tlast(target_last),

        .m_axis_data_tdata(incoming_i2c_data),
        .m_axis_data_tvalid(incoming_data_valid),
        .m_axis_data_tready(ready_for_incoming_data),
        .m_axis_data_tlast(incoming_data_last),

        .scl_i(scl_i),
        .scl_o(scl_o),
        .scl_t(scl_t),
        .sda_i(sda_i),
        .sda_o(sda_o),
        .sda_t(sda_t),

        .busy(module_busy),
        .bus_control(module_in_control_of_bus),
        .bus_active(bus_busy),
        .missed_ack(missed_ack),

        .prescale(16'h000A), //set prescale to 1/4 of the minimum clock period in units of input clk cycles (prescale = Fclk / (FI2Cclk * 4))
        .stop_on_idle(1'b1)

    );






endmodule