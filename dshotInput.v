module dshotInput(
    input wire clk,
    input wire inPin,
    output wire [10:0] setSpeed,
    output wire [5:0] specialCommand,
    output wire isSpecialCommand,
    output wire CRCValid,
    output reg processing,
    output wire isValidSpeed,
    output wire telemetryBit,
    output debugHalfClk
);


//internal signals
reg reset=1;
wire inSignal;
reg [4:0] bitcount=0; //16 bits in valid message
reg [4:0] lowSignalCount=0; //validate that signal drops to low too
reg [15:0] rawData=0;
reg [15:0] newRawData=0;
reg newDataReady = 0;

synchronizer in_sync (
    .clk(clk),
    .async_in(inPin),
    .sync_out(inSignal)
);

wire clockOut, halfClockOut, quarterClockOut;

baudrate16MHz #(
        .BAUD(150000)
        ) baudTimer (
        .clk_in(clk),
        .enable(!reset),
        .clk_out(clockOut),
        .half_clk_out(halfClockOut),
        .quarter_clk_out(quarterClockOut)
);
assign debugHalfClk = halfClockOut;

dshotProcessing dsprocess (
    .rawData(rawData),
    .setSpeed(setSpeed),
    .specialCommand(specialCommand),
    .isSpecialCommand(isSpecialCommand),
    .CRCValid(CRCValid),
    .isValidSpeed(isValidSpeed),
    .telemetryBit(telemetryBit)
);

//registers for edge detection of signals not tied to the main clock domain
reg inPin_prev;
reg halfClockOut_prev;
reg quarterClockOut_prev;

always @(posedge clk) begin

    if(inPin && !inPin_prev) begin//always @(posedge inPin) begin
        if(reset) begin
            reset <= 1'b0; //clear reset
            processing <= 1'b1;
            bitcount <= 5'b00000;
            lowSignalCount <= 5'b00000;
            newRawData <= 16'h0000;
        end
    end

    //positive edge of quarter clock indicates a sample we want
    if(quarterClockOut && !quarterClockOut_prev) begin//always @(posedge quarterClockOut) begin
        if(processing) begin
            if(!halfClockOut) begin //first quarter of signal, input should always be high if valid
                if(!inSignal) begin
                    reset <= 1'b1;
                    processing <= 1'b0;
                end
            end
        end
    end
    if (halfClockOut && !halfClockOut_prev) begin  //middle of signal, will contain data bit
        if(bitcount < 5'd16) begin
            newRawData <= (newRawData << 1) | inSignal; //shift in the new bit
            if(bitcount == 5'd15 && lowSignalCount == 5'd15 ) begin
                //set a flag to process new data next cycle, after it's shifted into rawdata
                newDataReady <= 1;
            end
            bitcount <= bitcount + 1;
        end
    end
    if(newDataReady) begin

        rawData <= newRawData;
        //uses dshotProcessing module declared below to process rawData :)
        reset <= 1'b1;
        processing <= 1'b0;

    end


    //count negative edges to verify a valid signal
    if (!inPin && inPin_prev) begin //always @(negedge inPin) begin
        if(processing) begin
            lowSignalCount <= lowSignalCount + 1;
        end
    end

    inPin_prev <= inPin;
    halfClockOut_prev <= halfClockOut;
    quarterClockOut_prev <= quarterClockOut;
end









endmodule


//dshot data validation and processing module

module dshotProcessing (
    input wire  [15:0] rawData,
    output wire [10:0] setSpeed,
    output wire [5:0] specialCommand,
    output wire isSpecialCommand,
    output wire CRCValid,
    output wire isValidSpeed,
    output wire telemetryBit
);

wire [11:0] CRCData;

assign setSpeed = rawData[15:5] - 48; //remove special commands
assign specialCommand = rawData[5:0]; //correlate value to special command
assign isSpecialCommand = (rawData < 48); //important to check if data is speed or command

assign CRCData = (rawData[15:4] ^ (rawData[15:4] >> 4) ^ (rawData[15:4] >> 8));
assign CRCValid = (CRCData[3:0] == rawData[3:0]);

assign isValidSpeed = (CRCValid && !isSpecialCommand);
assign telemetryBit = rawData[4];
endmodule