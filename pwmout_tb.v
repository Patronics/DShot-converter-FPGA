module pwmout_tb;

reg clk;
reg enable;
reg [7:0] targetSpeed;
wire pwmPin;

pwmout uut(
    .clk(clk),
    .enable(enable),
    .targetSpeed(targetSpeed),
    .pwmPin(pwmPin)
);

  // Clock generation
    always begin
        #1 clk = ~clk;  // Toggle clock every 10 time units
    end

// Test procedure
    initial begin
        // Initialize signals
        clk = 0;
        enable = 0;

        $dumpfile("pwmout_tb.vcd");
	    $dumpvars(2, uut);

        // Apply enable signal

        #2000000;
        enable = 1;
        targetSpeed = 0;

        #2000000;
        targetSpeed = 128;


        #2000000
        targetSpeed = 255;


        // Run simulation for a while
        #2000000;

        // End simulation
        $finish;
    end


endmodule