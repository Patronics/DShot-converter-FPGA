module dshotProcessing_tb;

 reg [15:0] rawData;
 wire [10:0] setSpeed;
 wire [5:0] specialCommand;
 wire isSpecialCommand;
 wire CRCValid;
 wire validSpeed;

dshotProcessing uut(
    .rawData(rawData),
    .setSpeed(setSpeed),
    .specialCommand(specialCommand),
    .isSpecialCommand(isSpecialCommand),
    .CRCValid(CRCValid),
    .validSpeed(validSpeed)
);


    initial begin
        rawData = 16'b0;
        $dumpfile("dshotProcessing_tb.vcd");
        $dumpvars(1, rawData, setSpeed, specialCommand, isSpecialCommand, CRCValid, validSpeed);

        #10
        rawData = 16'b1000001011000110;

        //TODO ADD MORE TEST CASES
        #100


        $finish;
    end


endmodule