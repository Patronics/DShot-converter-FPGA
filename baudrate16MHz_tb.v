// tb_baudrate16MHz.v
module tb_baudrate16MHz;

    // Testbench signals
    reg clk_in;
    reg enable;
    wire clk_out;
    wire half_clk_out;
    wire quarter_clk_out;

    // Instantiate the baudrate16MHz module
    baudrate16MHz uut (
        .clk_in(clk_in),
        .enable(enable),
        .clk_out(clk_out),
        .half_clk_out(half_clk_out),
        .quarter_clk_out(quarter_clk_out)
    );

    // Clock generation
    always begin
        #10 clk_in = ~clk_in;  // Toggle clock every 10 time units
    end

    // Test procedure
    initial begin
        // Initialize signals
        clk_in = 0;
        enable = 0;

        $dumpfile("baudrate16MHz_tb.vcd");
	    $dumpvars(1, clk_in, enable, clk_out, half_clk_out, quarter_clk_out);

        // Apply enable signal

        #2000;
        enable = 1;
        

        // Run simulation for a while
        #10000;

        // End simulation
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time = %0d, clk_in = %b, enable = %b, clk_out = %b, half_clk_out = %b, quarter_clk_out = %b", 
                 $time, clk_in, enable, clk_out, half_clk_out, quarter_clk_out);
    end

endmodule