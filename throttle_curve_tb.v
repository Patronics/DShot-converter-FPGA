`timescale 1ns / 1ps

module throttle_curve_tb;

    reg [7:0] throttle_in;
    wire [7:0] pwm_out;
    
    // Instantiate the throttle_curve module
    throttle_curve uut (
        .throttle_in(throttle_in),
        .pwm_out(pwm_out)
    );

    // Create a VCD dumpfile for waveform viewing
    initial begin
        $dumpfile("throttle_curve_tb.vcd");
        $dumpvars(0, throttle_curve_tb);
    end
    
    // Apply test vectors
    initial begin
        // Test for intermediate values within each LUT zone
        throttle_in = 8'd0;    #10;
        throttle_in = 8'd12;   #10;
        throttle_in = 8'd25;   #10;
        throttle_in = 8'd38;   #10;
        throttle_in = 8'd50;   #10;
        throttle_in = 8'd64;   #10;
        throttle_in = 8'd80;   #10;
        throttle_in = 8'd100;  #10;
        throttle_in = 8'd130;  #10;
        throttle_in = 8'd170;  #10;
        throttle_in = 8'd255;  #10;

        // Testing intermediate values for interpolation
        throttle_in = 8'd6;    #10;
        throttle_in = 8'd19;   #10;
        throttle_in = 8'd40;   #10;
        throttle_in = 8'd60;   #10;
        throttle_in = 8'd77;   #10;
        throttle_in = 8'd94;   #10;
        throttle_in = 8'd110;  #10;
        throttle_in = 8'd142;  #10;
        throttle_in = 8'd187;  #10;
        throttle_in = 8'd210;  #10;

        // End simulation
        #50;
        $finish;
    end

endmodule
