module dshotProcessing_tb;

 reg [15:0] rawData;
 wire [10:0] setSpeed;
 wire [5:0] specialCommand;
 wire isSpecialCommand;
 wire CRCValid;
 wire isValidSpeed;
 wire telemetryBit;

dshotProcessing uut(
    .rawData(rawData),
    .setSpeed(setSpeed),
    .specialCommand(specialCommand),
    .isSpecialCommand(isSpecialCommand),
    .CRCValid(CRCValid),
    .isValidSpeed(isValidSpeed),
    .telemetryBit(telemetryBit)
);


    initial begin
        rawData = 16'b0;
        $dumpfile("dshotProcessing_tb.vcd");
        $dumpvars(1, rawData, setSpeed, specialCommand, isSpecialCommand, CRCValid, isValidSpeed, telemetryBit);

        #10
        //sample test case in online example
        rawData = 16'b1000001011000110;

        #20
        //same test case as above but invalid CRC
        rawData = 16'b1000001011000101;

        //TODO ADD MORE TEST CASES
        #100


        $finish;
    end


endmodule