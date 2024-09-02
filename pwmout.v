module pwmout (
    input wire clk,
    input wire enable,
    input wire [7:0] targetSpeed,
    output wire pwmPin

);

wire outputStart;
reg minPulseEnable = 1'b0;
wire minPulseDone;
reg [7:0] currentTargetSpeed;
wire pulseStep;
reg pulseActive = 1'b0;
reg pulseDone;
reg [7:0] counter = 8'h00;

baudrate #(
    .BAUD(50)
) repeat_cycler (
    .clk_in(clk),
    .enable(enable),
    .clk_out(outputStart)

);

baudrate #(
    .BAUD(1000)
) minPulse (
    .clk_in(clk),
    .enable(minPulseEnable),
    .clk_out(minPulseDone)

);

baudrate #(
    .BAUD(255000)
) pulseSteps (
    .clk_in(clk),
    .enable(pulseActive),
    .clk_out(pulseStep)

);
always @(posedge clk) begin
    if (outputStart) begin //every 20ms
    minPulseEnable <= 1'b1;
    currentTargetSpeed <= targetSpeed;
    end

    if (minPulseDone) begin
        minPulseEnable <= 1'b0;
        pulseActive <= 1'b1;
    end

    if (pulseStep) begin
        counter <= counter + 1;
        if(counter >= currentTargetSpeed) begin
            pulseDone <= 1'b1;
            counter <= 0;
        end
    end
    if (pulseDone) begin
         pulseActive <= 1'b0;
        pulseDone <= 1'b0;
    end
end


   


//TODO should minimum speed be sent when enable false?
assign pwmPin = enable && (minPulseEnable || pulseActive);

endmodule