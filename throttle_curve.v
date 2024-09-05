module throttle_curve (
    input [7:0] throttle_in,  // 8-bit input throttle (0-255)
    output reg [7:0] pwm_out  // 8-bit output PWM (0-255)
);

always @(*) begin

    //10 is minimum consistient valid speed on this motor driver, corresponding to 3700RPM
    pwm_out = throttle_in / 4;  // default speed
    if (throttle_in < 40) begin
        pwm_out = 0;
    end else if (throttle_in < 120) begin
        pwm_out = (throttle_in / 6);  // add a bit so it spins up
    end else if (throttle_in < 210) begin
        pwm_out = (throttle_in / 4);  // add a bit so it spins up
    end else begin //if (throttle_in > 230) begin
        pwm_out = throttle_in;  // high speeds should match
    end

    
end

endmodule
