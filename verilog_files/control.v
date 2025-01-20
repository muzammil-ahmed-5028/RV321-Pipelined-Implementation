module control(
    input wire[6:0] opCode_I,
    output wire memReadEnable_O,
    output wire reg_W_EN_O, 
    output wire aluSrcB_O,
    output wire aluSrcA_O,
    output wire aluOp_O,
    output wire memWriteEn_O,
    output wire branchInst_O,
    output wire ItypeInsts_O,
    output wire jumpTypeInst_O,
    output wire [1:0] destRegWriteSel_O
);
// for register mux select: bit[1] = opCODE_I [5] & opCode_I[2]
// for register mux select: bit[0] =(~opCODE_I[6] & ~opCode_I[4]) | (~opCode_I[6] & opCode_I[5] & opCode_I[2])
// alu result = 0110011 bit[1] = 1&0 = 0 
// // bit[0] = (1 & 0) | (1&1&0) = 0 
// 10 for alu result
//
// memRead bit[1] = 0000011 = bit[1] = 0&0 bit[0] = (1& 1)| (1 &0 &0 ) = 1 ==
// 01 for memRead
// pc+4 to rd bit 1101111 bit[1] = 1&1 = 1  bit[0] = (0&1) | (0&1&1) =0 
// pc+4 = 10
// 11 for immWriteback 

assign memReadEnable_O = (opCode_I == 7'b0000011); 
wire  reg_W_EN_when_zero;
assign jumpTypeInst_O = opCode_I[6] & opCode_I[5] & opCode_I[2];
assign ItypeInsts_O = ~opCode_I[6] & ~opCode_I[5] & opCode_I[4] & ~opCode_I[2];
assign reg_W_EN_when_zero = opCode_I[5] ? opCode_I[4] : 1'b1;
assign aluSrcA_O =(opCode_I[3] | (opCode_I[6] & ~(opCode_I[2]))) ;
assign aluSrcB_O = ~(opCode_I[5] & opCode_I[4]);
assign reg_W_EN_O =( opCode_I[6] ? opCode_I[2] : reg_W_EN_when_zero) & (opCode_I != 7'b0000000);
assign aluOp_O = opCode_I[4] & ~opCode_I[2];
assign memWriteEn_O = (opCode_I[5] & ~opCode_I[4]) & ~opCode_I[6];
assign destRegWriteSel_O[0] = (~opCode_I[6] & ~opCode_I[4] ) | (~opCode_I[6] & opCode_I[5] & opCode_I[2]);
assign destRegWriteSel_O[1] = opCode_I[5] & opCode_I[2];
assign branchInst_O = opCode_I[6] & opCode_I[5];
endmodule

