//translate speeds from dshot to 0-255 output motor speeds

module speedhandler (
    input wire clk, 
    input wire dshotPin,
    output wire [7:0] outputSpeed
);

    wire [10:0] dshotSetSpeed;
    wire [5:0] dshotSpecialCommand;
    wire dshotIsSpecialCommand;
    wire dshotCRCValid;
    wire dshotProcessing;
    wire dshotIsValidSpeed;
    wire dshotTelemetryBit;

    dshotInput dshot(
        .clk(clk),
        .inPin(dshotPin),
        .setSpeed(dshotSetSpeed),
        .specialCommand(dshotSpecialCommand),
        .isSpecialCommand(dshotIsSpecialCommand),
        .CRCValid(dshotCRCValid),
        .processing(dshotProcessing),
        .isValidSpeed(dshotIsValidSpeed),
        .telemetryBit(dshotTelemetryBit)
    );

    reg [10:0] lastValidSpeed;

    reg processingComplete;
    reg delayedProcessingComplete; //allow a cycle for combinational logic to stabilize
    always @(negedge dshotProcessing) begin
        processingComplete <= 1'b1;
    end

    always @(posedge clk) begin
        delayedProcessingComplete <= processingComplete;
        if(delayedProcessingComplete) begin //  <= is non-blocking assignment so this happens one cycle after processingComplete goes true
            if(dshotIsValidSpeed) begin
                lastValidSpeed <= dshotSetSpeed;
            end
            if(dshotIsSpecialCommand && dshotCRCValid) begin
                //handle special commands
                if(dshotSpecialCommand == 1'b0) begin //DSHOT_CMD_MOTOR_STOP
                    lastValidSpeed <= 11'b00000000000;
                end
            end
        end

    end

    assign outputSpeed = lastValidSpeed[10:3];

endmodule