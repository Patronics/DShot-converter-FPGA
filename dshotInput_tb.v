//`timescale 1us/3125ps

module dshotInput_tb;

reg clk=0;
reg inPin=0;
wire [10:0] setSpeed;
wire [5:0] specialCommand;
wire isSpecialCommand;
wire CRCValid;
wire processing;
wire isValidSpeed;
wire telemetryBit;


dshotInput uut(
    .clk(clk),
    .inPin(inPin),
    .setSpeed(setSpeed),
    .specialCommand(specialCommand),
    .isSpecialCommand(isSpecialCommand),
    .CRCValid(CRCValid),
    .processing(processing),
    .isValidSpeed(isValidSpeed),
    .telemetryBit(telemetryBit)
);

    // Clock generation
    always begin
        #0.03125 clk = ~clk;  // Toggle clock every time unit


    end
    // rawData = 16'b 1 000001011000110;

    initial begin
        $dumpfile("dshotInput_tb.vcd");
        $dumpvars(2, uut);
        #10
        send_command(16'b1000001011000110);
        // rawData = 16'b1000001011000110;

        #10;
        $finish;

    end


    task send_command(input [15:0] data_in);
        integer i;
        begin
            for (i = 0; i < 16; i = i + 1) begin
                send_bit(data_in[i]);

            end
        end
    endtask

    task send_bit(input bit_in);
        if(bit_in) begin
            inPin = 1;
            #5;
            inPin = 0;
            #1.67;
        end else begin //bit is 0
            inPin = 1;
            #2.5;
            inPin = 0;
            #4.17;
        end


    endtask



endmodule