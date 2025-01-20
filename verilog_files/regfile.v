module regfile(
    input wire clk_I,
    input wire w_en_I,
    input wire r_en_I,
    input wire [4:0] addrRegA_I,
    input wire [4:0] addrRegB_I,
    input wire [4:0] destReg_I,
    input wire [31:0] destRegWrite_I,
    output reg [31:0] dataRegA_O,
    output reg [31:0] dataRegB_O,
	 output wire [23:0] x2_data
);
reg [31:0] Register [31:0];

always @(*) begin
    // Default assignments to prevent latch inference
    dataRegA_O = 0;
    dataRegB_O = 0;

    if (r_en_I) begin
        // Read from Register A if address is non-zero, otherwise keep it at 0
        if (addrRegA_I) 
            dataRegA_O = Register[addrRegA_I]; 

        // Read from Register B if address is non-zero, otherwise keep it at 0
        if (addrRegB_I) 
            dataRegB_O = Register[addrRegB_I]; 
    end
end


always@(posedge clk_I) begin
    if(w_en_I) begin
        if(destReg_I) Register[destReg_I] <= destRegWrite_I; 
    end
end

assign x2_data = Register[5][23:0];
endmodule
