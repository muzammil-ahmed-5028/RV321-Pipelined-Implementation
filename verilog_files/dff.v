module dff_1(
    input wire [31:0] D,
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [31:0] Q
);
always@(posedge clk or negedge reset) begin
    if(!reset) Q <= 0;
    else begin
        if(enable) Q <= D;
    end
end
endmodule
