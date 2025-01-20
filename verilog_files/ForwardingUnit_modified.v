module ForwardingUnit(
    input wire [4:0] MEM_rdAddr,
    input wire [4:0] WB_rdAddr,
    input wire [4:0] EX_rs1Addr,
    input wire [4:0] EX_rs2Addr,
	 input wire [4:0] ID_rs1Addr,
	 input wire [4:0] ID_rs2Addr,
	 input wire [6:0] ID_opCode, //	 
    input wire MEM_reg_W_En, //
    input wire WB_reg_W_En, //
    input wire [6:0] MEM_opCode, //
    input wire [6:0] WB_opCode,//
    input wire [6:0] EX_opCode,//
    output wire [1:0] forwardALUSrcA,
    output wire [1:0] forwardALUSrcB,
    output wire [1:0] forwardRs2Src,
	 output wire forwardRFSrcA,
	 output wire forwardRFSrcB
);

wire MEM_forwardRs1_toEX; //Type 1 forwarding
wire MEM_forwardRs2_toEX;
wire WB_forwardRs1_toEX;
wire WB_forwardRs2_toEX;

wire MEM_forwardRs2_toMEM; //Type 2 forwarding 
wire WB_forwardRs2_toMEM;

wire WB_forwardRs1_toID; //Reg File Forwarding
wire WB_forwardRs2_toID;
/*
----------------------------------------------------------
Reg File Mux A (2 input mux)
0: Send the original read rs1
1: Send forwarded rs1 from WB 

Reg File Mux B (2 input mux) 
0: Send the original read rs2
1: Send forwarded rs2 from WB
-----------------------------------------------------------
Muxes for EX and MEM forwarding (3 input muxes) 
00: Send original register 
01: Send register forwarded from WB 
10: Send register forwarded from MEM 
11: Dont care condition 
-------------------------------------------------------------
*/


assign MEM_forwardRs1_toEX = MEM_reg_W_En && !(MEM_rdAddr == 5'b00000) && !(MEM_opCode==7'b0000011)&&(MEM_rdAddr == EX_rs1Addr) && !(EX_opCode==7'b0x10111) && !(EX_opCode==7'b1101111);
assign MEM_forwardRs2_toEX = MEM_reg_W_En && (MEM_rdAddr != 5'b00000) && (MEM_rdAddr == EX_rs2Addr)&& ((EX_opCode==7'b0110011) || (EX_opCode==7'b1100011));
assign WB_forwardRs1_toEX = WB_reg_W_En && (WB_rdAddr != 5'b00000) && (WB_rdAddr == EX_rs1Addr)&& !(EX_opCode==7'b0x10111) && !(EX_opCode==7'b1101111);
assign WB_forwardRs2_toEX = WB_reg_W_En && (WB_rdAddr != 5'b00000) && (WB_rdAddr == EX_rs2Addr)&& ((EX_opCode==7'b0110011) || (EX_opCode==7'b1100011));

assign MEM_forwardRs2_toMEM = MEM_reg_W_En && !(MEM_rdAddr == 5'b00000) && (EX_opCode==7'b0100011) && (MEM_rdAddr == EX_rs2Addr) && !(MEM_opCode==7'b0000011);
assign WB_forwardRs2_toMEM = (WB_reg_W_En) && (WB_rdAddr == EX_rs2Addr) && (EX_opCode==7'b0100011) && !(WB_rdAddr == 5'b00000);

assign WB_forwardRs1_toID = WB_reg_W_En && !(WB_rdAddr == 5'b00000) && (ID_rs1Addr == WB_rdAddr) && !(ID_opCode == 7'b0x10111)  && !(ID_opCode == 7'b1101111);
//assign WB_forwardRs2_toID = WB_reg_W_En && !(WB_rdAddr == 5'b00000) && (ID_rs2Addr == WB_rdAddr) && ((EX_opCode==7'b0110011) || (EX_opCode==7'b1100011) || (EX_opCode==7'b0100011));
assign WB_forwardRs2_toID = WB_reg_W_En && !(WB_rdAddr == 5'b00000) && (ID_rs2Addr == WB_rdAddr) && ((ID_opCode==7'b0110011) || (ID_opCode==7'b1100011) || (ID_opCode==7'b0100011));



//Final Control Signals

assign forwardALUSrcA = MEM_forwardRs1_toEX ? 2'b10: WB_forwardRs1_toEX ? 2'b01: 2'b00;
assign forwardALUSrcB = MEM_forwardRs2_toEX ? 2'b10: WB_forwardRs2_toEX ? 2'b01: 2'b00;

assign forwardRs2Src = MEM_forwardRs2_toMEM ? 2'b10: WB_forwardRs2_toMEM ? 2'b01: 2'b00;

assign forwardRFSrcA = WB_forwardRs1_toID ? 1'b1 : 1'b0;
assign forwardRFSrcB = WB_forwardRs2_toID ? 1'b1 : 1'b0;

endmodule

