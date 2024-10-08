//`timescale 1us/3125ps

module speedhandler_tb;

reg clk=0;
reg inPin=0;
wire [7:0] outputSpeed;
wire [5:0] specialCommand;
wire isSpecialCommand;
wire CRCValid;
wire processing;
wire isValidSpeed;
wire telemetryBit;


speedhandler uut(
    .clk(clk),
    .dshotPin(inPin),
    .outputSpeed(outputSpeed)
);

    // Clock generation
    always begin
        #0.03125 clk = ~clk;  // Toggle clock every time unit


    end
    // rawData = 16'b 1 000001011000110;

    reg curbit;

    initial begin
        $dumpfile("speedhandler_tb.vcd");
        $dumpvars(3, uut, inPin, curbit);
        inPin = 1;
        #105
        inPin = 0;

        #100
        send_command(16'b1000001011000110);
        // rawData = 16'b1000001011000110;

        #140;
        send_command(16'hdea9);

        #140;
        send_command(16'b1000001011000110);

        #53
        send_bit(1); //corrupted message
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(0);



        #140;
        //maximum speed
        send_command(16'hffee);

        #150

        $finish;

    end


    task send_command(input [15:0] data_in);
        integer i;
        begin
            for (i = 15; i >= 0; i = i - 1) begin
                send_bit(data_in[i]);
                curbit = data_in[i];
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