module synchronizer (
    input wire clk,
    input wire async_in,
    output reg sync_out
);

reg d1;

always @(posedge clk) begin
    d1 <= async_in;
    sync_out <= d1;
end

endmodule