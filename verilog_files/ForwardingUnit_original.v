module forwardingUnit(
    input wire [4:0] MEM_rdAddr,
    input wire [4:0] WB_rdAddr,
    input wire [4:0] EX_rs1Addr,
    input wire [4:0] EX_rs2Addr,
    input wire MEM_reg_W_En,
    input wire WB_reg_W_EN,
    output reg [1:0] forwardALUSrcA,
    output reg [1:0] forwardALUSrcB
);

wire MEM_forwardRs1;
wire MEM_forwardRs2;
wire WB_forwardRs1;
wire WB_forwardRs2;
assign MEM_forwardRs1 = MEM_reg_W_En & (MEM_rdAddr != 5'b00000) & (MEM_rdAddr == EX_rs1Addr);
assign MEM_forwardRs2 = MEM_reg_W_En & (MEM_rdAddr != 5'b00000) & (MEM_rdAddr == EX_rs2Addr);
assign WB_forwardRs1 = WB_reg_W_EN & (WB_rdAddr != 5'b00000) & (WB_rdAddr == EX_rs1Addr);
assign WB_forwardRs2 = WB_reg_W_EN & (WB_rdAddr != 5'b00000) & (WB_rdAddr == EX_rs2Addr);

always@(*)begin
    case({MEM_forwardRs1,WB_forwardRs1}) 
        2'b11: forwardALUSrcA = 2'b10;
        2'b10: forwardALUSrcA = 2'b10;
        2'b01: forwardALUSrcA = 2'b01;
        2'b00: forwardALUSrcA = 2'b00;
        default: forwardALUSrcA = 2'b00;
    endcase

    case({MEM_forwardRs2,WB_forwardRs2}) 
        2'b11: forwardALUSrcB = 2'b10;
        2'b10: forwardALUSrcB = 2'b10;
        2'b01: forwardALUSrcB = 2'b01;
        2'b00: forwardALUSrcB = 2'b00;
        default: forwardALUSrcB = 2'b00;
    endcase
end
endmodule

