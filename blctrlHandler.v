module blctrlHandler (
    input wire clk,
    input wire masterEnable,   //not currently implemented
    input wire [0:7] motorEnable,  //not currently implemented
    input wire [63:0] targetSpeedFlat,  //array of 8 entries of 8-bit target speeds, packed into a 64 bit block as required by older versions of verilog

    input  wire        scl_i,
    output wire        scl_o,
    output wire        scl_t,
    input  wire        sda_i,
    output wire        sda_o,
    output wire        sda_t
);

    reg [2:0] state = 0;

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
    assign currentTargetSpeed = targetSpeed[currentOutputCounter][7:0];

    reg cmd_start = 0;  //set start to force generation of a start condition, start is implied when bus is inactive or active with read or different address
    reg cmd_read = 0; //not yet used
    reg cmd_write = 1;
    reg cmd_write_multiple = 0;
    reg cmd_stop = 0;   //    set stop to issue a stop condition after writing current byte
    reg cmd_valid =0;
    wire cmd_ready;

    //s_axis_data_tdata is currentTargetSpeed
    reg valid_output;
    wire target_ready;
    reg target_last;

    wire [7:0] incoming_i2c_data;
    wire incoming_data_valid;
    reg ready_for_incoming_data = 0;
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

    reg rst_stopstart_delay;
    wire delay_done;
    delay_stopstart messageGap(
        .clk(clk),
        .rst(rst_stopstart_delay),
        .done(delay_done)
    );

    always @(posedge clk) begin
        case (state)
            0: begin
                if(!bus_busy) begin //send write command to device
                    cmd_write <= 1;
                    cmd_valid <= 1;
                    cmd_stop <= 1;
                    if (cmd_ready && cmd_valid) begin
                        state <= 1;
                        cmd_valid <= 0;
                    end
                end
            end
            1: begin
                valid_output <= 1;
                target_last <= 1;
                if (target_ready && valid_output) begin
                    valid_output <= 0;
                    state <= 2;
                end
            end
            2: begin
                if (cmd_ready) begin 
                    cmd_stop <= 1;
                    cmd_write <= 0;
                    cmd_valid <= 1;
                end
                if (cmd_ready && cmd_valid) begin
                    cmd_valid <= 0;
                    currentOutputCounter <= currentOutputCounter + 1; //move on to next slave address
                    rst_stopstart_delay <= 1;
                    state <= 3;
                end


            end
            3: begin
                rst_stopstart_delay <= 0;
                if(delay_done) begin
                    state <= 0;
                end


            end
        endcase
    end

    //TODO control more precisely
    /*assign cmd_write = 1;
    assign cmd_valid = 1;
    assign valid_output = 1;
    assign target_last = 1;*/


endmodule


module delay_stopstart (
    input wire clk,        // 16 MHz clock signal
    input wire rst,        // Reset signal
    output reg done        // Signal indicating delay completion
);

    // Parameter for the number of clock cycles for 4ms delay
    localparam DELAY_CYCLES = 480;

    // Register to hold the counter value
    reg [8:0] counter; // 16 bits are enough to count up to 64,000

    // Main process
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset the counter and done signal
            counter <= 9'd0;
            done <= 1'b0;
        end else if (counter < DELAY_CYCLES) begin
            // Increment the counter until the delay is reached
            counter <= counter + 1;
            done <= 1'b0;
        end else begin
            // Set the done signal high when the delay is complete
            done <= 1'b1;
        end
    end

endmodule