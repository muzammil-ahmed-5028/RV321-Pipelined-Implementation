module IF_ID_Register(
    input wire [31:0]  pcAddr_D_I,
    input wire [31:0] currInstruction_D_I,
    input wire [31:0] currInstructionAddrPlus4_D_I,
    input wire clk_I,
    input wire reset_I,
    input wire enable_I,
    output reg [31:0] pcAddr_Q_O,
    output reg [31:0] currInstruction_Q_O,
    output reg [31:0] currInstructionAddrPlus4_Q_O
);

always@(posedge clk_I or negedge reset_I) begin
    if(!reset_I) begin
        pcAddr_Q_O <= 32'h00000000;
        currInstruction_Q_O <= 32'h00000000;
        currInstructionAddrPlus4_Q_O <= 32'h00000000;
    end
    else begin
        pcAddr_Q_O <= enable_I ? pcAddr_D_I : pcAddr_Q_O;
        currInstruction_Q_O <= enable_I ? currInstruction_D_I :  currInstruction_Q_O;
        currInstructionAddrPlus4_Q_O <= enable_I ? currInstructionAddrPlus4_D_I : currInstructionAddrPlus4_Q_O;
    end
end

endmodule
