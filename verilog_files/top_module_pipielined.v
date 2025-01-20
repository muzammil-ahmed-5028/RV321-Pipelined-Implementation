module top_pipelined(
    input wire clk_I,
    input wire reset_I,
	output wire [41:0] sevenSegDisplay // stuff for this at the end
);
// IF wires
wire [31:0] IF_currInstruction;
wire [31:0] IF_currInstructionAddrPlus4;
reg [31:0] IF_nextInstructionAddr; // make mux for this
wire [31:0] IF_currInstructionAddr;
wire [31:0] ID_currInstructionAddr;
wire [31:0] ID_currInstructionAddrPlus4;
wire [31:0] ID_currInstruction;
reg [31:0] IF_currInstructionAfterFlushing;
wire IF_flushSignal;
wire IF_pcEnable;
wire IF_ID_registerEnable;

always@(*) begin
	case(MEM_branchTaken & MEM_branchInst)
		1'b1: IF_nextInstructionAddr =  MEM_aluResult;
		1'b0: IF_nextInstructionAddr = IF_currInstructionAddrPlus4;
		default: IF_nextInstructionAddr = IF_currInstructionAddrPlus4;
	endcase
end

dff_1 DFF(
	.D(IF_nextInstructionAddr),	 // signal length = 32
	.clk(clk_I),	 // signal length = 1 
	.reset(reset_I),	 // signal length = 1 
	.enable(IF_pcEnable),	 // signal length = 1 
	.Q(IF_currInstructionAddr)	 // signal length = 32
);

four_adder FOUR_ADDER(
	.B_I(IF_currInstructionAddr),	 // signal length = 32
	.C_O(IF_currInstructionAddrPlus4)	 // signal length = 32
);

insts_ROM INST_MEM(
	.inst_addr(IF_currInstructionAddr[31:2]),	 // signal length = 29
	.inst(IF_currInstruction)	 // signal length = 32
);

always@(*)begin
    case(IF_flushSignal)
        1'b1: IF_currInstructionAfterFlushing = 32'h00000000;
        1'b0: IF_currInstructionAfterFlushing = IF_currInstruction;
        default: IF_currInstructionAfterFlushing = IF_currInstruction;
    endcase
end

IF_ID_Register IF_ID_REGISTER(
	.pcAddr_D_I(IF_currInstructionAddr),	 // signal length = 32
	.currInstruction_D_I(IF_currInstructionAfterFlushing),	 // signal length = 32
	.currInstructionAddrPlus4_D_I(IF_currInstructionAddrPlus4),	 // signal length = 32
	.clk_I(clk_I),	 // signal length = 1
	.reset_I(reset_I),	 // signal length = 1
	.enable_I(IF_ID_registerEnable),	 // signal length = 1
	.pcAddr_Q_O(ID_currInstructionAddr),	 // signal length = 32
	.currInstruction_Q_O(ID_currInstruction),	 // signal length = 32
	.currInstructionAddrPlus4_Q_O(ID_currInstructionAddrPlus4)	 // signal length = 32
);

wire ID_reg_w_en;
wire ID_aluSrcB;
wire ID_aluSrcA;
wire ID_aluOp;
wire ID_memWriteEn;
wire ID_branchInst;
wire ID_ItypeInsts;
wire ID_jumpTypeInst;
wire [1:0] ID_destRegWriteSel;
wire ID_memReadEnable;
reg ID_memReadEnableAfterFlush;
reg ID_regWriteAfterFlush;
wire ID_bubbleSelect;
reg [31:0] ID_rs1AfterForwarding;
reg [31:0] ID_rs2AfterForwarding;
wire ID_rfRs1Sel;
wire ID_rfRs2Sel;
wire [31:0] x2_data;
control CONTROL(
	.opCode_I(ID_currInstruction[6:0]),	 // signal length = 1 
	.reg_W_EN_O(ID_reg_w_en),	 // signal length = 1 
	.aluSrcB_O(ID_aluSrcB),	 // signal length = 1 
	.aluSrcA_O(ID_aluSrcA),	 // signal length = 1 
	.aluOp_O(ID_aluOp),	 // signal length = 1 
	.memWriteEn_O(ID_memWriteEn),	 // signal length = 1 
	.branchInst_O(ID_branchInst),	 // signal length = 1 
	.ItypeInsts_O(ID_ItypeInsts),	 // signal length = 1 
	.jumpTypeInst_O(ID_jumpTypeInst),	 // signal length = 1 
	.destRegWriteSel_O(ID_destRegWriteSel),  // signal length = 2
    .memReadEnable_O(ID_memReadEnable)
);

always@(*) begin
    case(ID_bubbleSelect)
        1'b1: begin
            ID_memReadEnableAfterFlush = 0;
            ID_regWriteAfterFlush = 0;
        end 
        default: begin
            ID_memReadEnableAfterFlush = ID_memReadEnable;
            ID_regWriteAfterFlush = ID_reg_w_en;
        end
    endcase
end

wire [31:0] ID_regRs1Data;
wire [31:0] ID_regRs2Data;
wire [31:0] ID_immData;

regfile REGFILE(
	.clk_I(clk_I),	 // signal length = 1
	.w_en_I(WB_reg_W_EN),	 // signal length = 1
	.r_en_I(1'b1),	 // signal length = 1
	.addrRegA_I(ID_currInstruction[19:15]),	 // signal length = 5
	.addrRegB_I(ID_currInstruction[24:20]),	 // signal length = 5
	.destReg_I(WB_rdAddr),	 // signal length = 5
	.destRegWrite_I(WB_rdDataWriteBack),	 // signal length = 32
	.dataRegA_O(ID_regRs1Data),	 // signal length = 32
	.dataRegB_O(ID_regRs2Data),	 // signal length = 32
	.x2_data(x2_data)
);

always@(*)begin
	case(ID_rfRs1Sel)
		1'b1: ID_rs1AfterForwarding = WB_rdDataWriteBack;
		1'b0: ID_rs1AfterForwarding = ID_regRs1Data;
		default: ID_rs1AfterForwarding = ID_regRs1Data;
	endcase 

	case(ID_rfRs2Sel)
		1'b1: ID_rs2AfterForwarding = WB_rdDataWriteBack;
		1'b0: ID_rs2AfterForwarding = ID_regRs2Data;
		default: ID_rs2AfterForwarding = ID_regRs2Data;
	endcase 
end

immGen IMMGEN(
	.instruction_I(ID_currInstruction),	 // signal length = 32
	.imm_O(ID_immData)	 // signal length = 32
);

wire [31:0] EX_regRs1Data;
wire [31:0] EX_regRs2Data;
wire [31:0] EX_immData;
wire [2:0] EX_func3;
wire [6:0] EX_func7;
wire [31:0] EX_currInstructionAddrPlus4;
wire [4:0] EX_destRegAddr;
wire EX_reg_W_EN;
wire EX_aluSrcB;
wire EX_aluSrcA;
wire EX_aluOp;
wire EX_memWriteEn;
wire EX_branchInst;
wire EX_ItypeInst;
wire EX_jumpTypeInst;
wire [1:0] EX_destWriteRegSelect;
wire [6:0] EX_opCode;
wire [4:0] EX_rs1Addr;
wire [4:0] EX_rs2Addr;
wire EX_memReadEnable;
wire EX_bubbleSelect;
reg EX_memReadEnableAfteFlush;
reg EX_reg_W_EN_AfterFlush;
wire [4:0] EX_rdAddr;
wire ID_EX_enable;
ID_EX_register ID_EX_REGISTER(
	.clk_I(clk_I),	 // signal length = 1 
	.reset_I(reset_I),	 // signal length = 1 
	.enable_I(ID_EX_enable),	 // signal length = 1 
	.ID_EX_rs1_I_D(ID_rs1AfterForwarding),	 // signal length = 32
	.ID_EX_rs2_I_D(ID_rs2AfterForwarding),	 // signal length = 32
	.imm_I_D(ID_immData),	 // signal length = 32
	.func3_I_D(ID_currInstruction[14:12]),	 // signal length = 3
	.func7_I_D(ID_currInstruction[31:25]),	 // signal length = 7
	.ID_EX_rdAddr_I_D(ID_currInstruction[11:7]),	 // signal length = 5
	.currInstructionAddrPlus4_I_D(ID_currInstructionAddrPlus4),	 // signal length = 32
	.reg_W_EN_I_D(ID_regWriteAfterFlush),	 // signal length = 1
	.aluSrcB_I_D(ID_aluSrcB),	 // signal length = 1
	.aluSrcA_I_D(ID_aluSrcA),	 // signal length = 1
	.aluOp_I_D(ID_aluOp),	 // signal length = 1
	.memWriteEn_I_D(ID_memWriteEn),	 // signal length = 1
	.branchInst_I_D(ID_branchInst),	 // signal length = 1
	.ItypeInsts_I_D(ID_ItypeInsts),	 // signal length = 1
	.jumpTypeInst_I_D(ID_jumpTypeInst),	 // signal length = 1
	.destRegWriteSel_I_D(ID_destRegWriteSel),	 // signal length = 2
	.rs1Addr_I_D(ID_currInstruction[19:15]),
    .rs2Addr_I_D(ID_currInstruction[24:20]),
    .opCode_I_D(ID_currInstruction[6:0]),
    .memReadEnable_I_D(ID_memReadEnableAfterFlush),
    .ID_EX_rs1_O_Q(EX_regRs1Data),	 // signal length = 32
	.ID_EX_rs2_O_Q(EX_regRs2Data),	 // signal length = 32
	.imm_O_Q(EX_immData),	 // signal length = 32
	.currInstructionAddrPlus4_O_Q(EX_currInstructionAddrPlus4),	 // signal length = 32
	.func3_O_Q(EX_func3),	 // signal length = 3
	.func7_O_Q(EX_func7),	 // signal length = 7
	.ID_EX_rdAddr_O_Q(EX_destRegAddr),	 // signal length = 5
	.reg_W_EN_O_Q(EX_reg_W_EN),	 // signal length = 1 
	.aluSrcB_O_Q(EX_aluSrcB),	 // signal length = 1 
	.aluSrcA_O_Q(EX_aluSrcA),	 // signal length = 1 
	.aluOp_O_Q(EX_aluOp),	 // signal length = 1 
	.memWriteEn_O_Q(EX_memWriteEn),	 // signal length = 1 
	.branchInst_O_Q(EX_branchInst),	 // signal length = 1 
	.ItypeInsts_O_Q(EX_ItypeInst),	 // signal length = 1 
	.jumpTypeInst_O_Q(EX_jumpTypeInst),	 // signal length = 1 
	.destRegWriteSel_O_Q(EX_destWriteRegSelect),	 // signal length = 2
    .opCode_O_Q(EX_opCode),
    .rs1Addr_O_Q(EX_rs1Addr),
    .rs2Addr_O_Q(EX_rs2Addr),
    .memReadEnable_O_Q(EX_memReadEnable)
);

always@(*) begin
    case(EX_bubbleSelect)
    1'b1:begin 
         EX_memReadEnableAfteFlush = 0;
         EX_reg_W_EN_AfterFlush = 0;
    end
    default: begin
        EX_memReadEnableAfteFlush = EX_memReadEnable;
        EX_reg_W_EN_AfterFlush = EX_reg_W_EN;
    end
endcase
end


wire [31:0] EX_currInstructionAddr;
assign EX_currInstructionAddr = EX_currInstructionAddrPlus4 - 32'h00000004;
wire [31:0] EX_aluSrcAData;
wire [31:0] EX_aluSrcBData;
wire [31:0] EX_aluResult;
wire [3:0] EX_aluFunc;
wire EX_branchTaken;
wire [6:0] MEM_opCode;
reg [31:0] Rs1AfterForwarding;
reg [31:0] Rs2AfterForwarding;
wire [1:0] forwardRs1Sel;
wire [1:0] forwardRs2Sel;
wire [1:0] forwardRs2ForStoreSel;
reg [31:0] rs2DataForStoreAfterForwarding;

always@(*) begin
    case(forwardRs1Sel)
        2'b00: Rs1AfterForwarding = EX_regRs1Data;
        2'b01: Rs1AfterForwarding = WB_rdDataWriteBack;
        2'b10: Rs1AfterForwarding = MEM_aluResult;
       default: Rs1AfterForwarding =  EX_regRs1Data;
   endcase
    case(forwardRs2Sel)
        2'b00: Rs2AfterForwarding = EX_regRs2Data;
        2'b01: Rs2AfterForwarding = WB_rdDataWriteBack;
        2'b10: Rs2AfterForwarding = MEM_aluResult;
       default: Rs2AfterForwarding =  EX_regRs2Data;
   endcase
   case(forwardRs2ForStoreSel)
		2'b00: rs2DataForStoreAfterForwarding = EX_regRs2Data;
		2'b01: rs2DataForStoreAfterForwarding = WB_rdDataWriteBack;
		2'b10: rs2DataForStoreAfterForwarding = MEM_aluResult;
		default: rs2DataForStoreAfterForwarding = EX_regRs2Data;
   endcase
end

assign EX_aluSrcAData = EX_aluSrcA ? EX_currInstructionAddr : Rs1AfterForwarding;
assign EX_aluSrcBData = EX_aluSrcB ? EX_immData: Rs2AfterForwarding;

ALU ALU(
	.regA_I(EX_aluSrcAData),	 // signal length = 32
	.regB_I(EX_aluSrcBData),	 // signal length = 32
	.aluOP_I(EX_aluFunc),	 // signal length = 4
	.result_O(EX_aluResult)	 // signal length = 32
);

aluCtrl ALUCTRL(
	.func3_I(EX_func3),	 // signal length = 3
	.func7_I(EX_func7),	 // signal length = 7
	.aluOp_I(EX_aluOp),	 // signal length = 1 
	.Itype_I(EX_ItypeInst),	 // signal length = 1 
	.aluFunc_O(EX_aluFunc)	 // signal length = 4
);

branchDecide BRANCHDECIDE(
	.rs1Data(Rs1AfterForwarding),	 // signal length = 32
	.rs2Data(Rs2AfterForwarding),	 // signal length = 32
	.func3(EX_func3),	 // signal length = 3
	.jumpTypeInstFlag(EX_jumpTypeInst),	 // signal length = 1 
	.branchTaken(EX_branchTaken)	 // signal length = 1 
);

wire [31:0] MEM_aluResult;
wire [31:0] MEM_rs2Data;
wire [2:0] MEM_func3;
wire [31:0] MEM_currInstructionAddrPlus4;
wire [31:0] MEM_immData;
wire MEM_branchTaken;
wire MEM_branchInst;
wire [1:0] MEM_destRegWriteSel;
wire MEM_reg_W_EN;
wire MEM_memWriteEn;
wire [4:0] MEM_rdAddr;
wire MEM_memReadEnable;

EX_MEM_register EX_MEM_REGISTER(
	.clk_I(clk_I),	 // signal length = 1 
	.reset_I(reset_I),	 // signal length = 1 
	.enable_I(1'b1),	 // signal length = 1  
	.aluResult_I_D(EX_aluResult),	 // signal length = 32
	.rs2Data_I_D(rs2DataForStoreAfterForwarding),	 // signal length = 32
	.func3_I_D(EX_func3),	 // signal length = 3
	.currInstructionAddrPlus4_I_D(EX_currInstructionAddrPlus4),	 // signal length = 32
	.imm_I_D(EX_immData),	 // signal length = 32
	.branchTaken_I_D(EX_branchTaken),	 // signal length = 1 
	.branchTypeInst_I_D(EX_branchInst),	 // signal length = 1 
	.destRegWriteSel_I_D(EX_destWriteRegSelect),	 // signal length = 2
	.memWriteEn_I_D(EX_memWriteEn),	 // signal length = 3
	.reg_W_En_I_D(EX_reg_W_EN),	 // signal length = 1 
	.opCode_I_D(EX_opCode),
    .rdAddr_I_D(EX_destRegAddr),
    .memReadEnable_I_D(EX_memReadEnable),
    .aluResult_O_Q(MEM_aluResult),	 // signal length = 32
	.rs2Data_O_Q(MEM_rs2Data),	 // signal length = 32
	.func3_O_Q(MEM_func3),	 // signal length = 3
	.currInstructionAddrPlus4_O_Q(MEM_currInstructionAddrPlus4),	 // signal length = 32
	.imm_O_Q(MEM_immData),	 // signal length = 32
	.branchTaken_O_Q(MEM_branchTaken),	 // signal length = 1 
	.branchTypeInst_O_Q(MEM_branchInst),	 // signal length = 1 
	.destRegWriteSel_O_Q(MEM_destRegWriteSel),	 // signal length = 2
	.memWriteEn_O_Q(MEM_memWriteEn),	 // signal length = 3
	.reg_W_En_O_Q(MEM_reg_W_EN),	 // signal length = 1 
    .rdAddr_O_Q(MEM_rdAddr),
    .opCode_O_Q(MEM_opCode),
    .memReadEnable_O_Q(MEM_memReadEnable)
);

wire [31:0] MEM_reData;

dataMem DATAMEM(
	.address_I(MEM_aluResult),	 // signal length = 32
	.wrData_I(MEM_rs2Data),	 // signal length = 32
	.memReadSel_I(MEM_func3),	 // signal length = 3
	.memWriteEn_I(MEM_memWriteEn),	 // signal length = 1 
	.memReadEnable_I(MEM_memReadEnable),
    .clk(clk_I),	 // signal length = 1 
	.reData(MEM_reData)	 // signal length = 32
);

wire [31:0] WB_memReadData;
wire [31:0] WB_aluResult;
wire [31:0] WB_currInstructionAddrPlus4;
wire [1:0] WB_destRegWriteSel;
wire [31:0] WB_immData;
wire WB_reg_W_EN;
wire [4:0] WB_rdAddr;
wire [6:0] WB_opCode;

MEM_WB_register MEM_WB_REGISTER(
	.clk_I(clk_I),	 // signal length = 1 
	.reset_I(reset_I),	 // signal length = 1 
	.enable_I(1'b1),	 // signal length = 1 
	.memReadData_I_D(MEM_reData),	 // signal length = 32
	.aluResult_I_D(MEM_aluResult),	 // signal length = 32
	.reg_W_EN_I_D(MEM_reg_W_EN),	 // signal length = 1 
	.destRegWriteSel_I_D(MEM_destRegWriteSel),	 // signal length = 2
	.currInstructionAddrPlus4_I_D(MEM_currInstructionAddrPlus4),	 // signal length = 32
	.imm_I_D(MEM_immData),	 // signal length = 32
	.rdAddr_I_D(MEM_rdAddr),
    .opCode_I_D(MEM_opCode),
    .memReadData_O_Q(WB_memReadData), // signal length = 32
	.aluResult_O_Q(WB_aluResult),	 // signal length = 32
	.reg_W_EN_O_Q(WB_reg_W_EN),	 // signal length = 1 
	.destRegWriteSel_O_Q(WB_destRegWriteSel),	 // signal length = 2
	.currInstructionAddrPlus4_O_Q(WB_currInstructionAddrPlus4),	 // signal length = 32
	.imm_O_Q(WB_immData),	 // signal length = 32
    .rdAddr_O_Q(WB_rdAddr),
    .opCode_O_Q(WB_opCode)
);

reg [31:0] WB_rdDataWriteBack;

always@(*) begin
    case(WB_destRegWriteSel) // gerber hai
       2'b00: WB_rdDataWriteBack = WB_aluResult;
       2'b01: WB_rdDataWriteBack = WB_memReadData;
       2'b10: WB_rdDataWriteBack = WB_currInstructionAddrPlus4;
       2'b11: WB_rdDataWriteBack = WB_immData;
       default: WB_rdDataWriteBack = WB_aluResult;
   endcase
end
/*
forwardingUnit FWDUNIT(
    .MEM_rdAddr(MEM_rdAddr),
    .WB_rdAddr(WB_rdAddr),
    .EX_rs1Addr(EX_rs1Addr),
    .EX_rs2Addr(EX_rs2Addr),
	.MEM_reg_W_En(MEM_reg_W_EN),
	.WB_reg_W_EN(WB_reg_W_EN),
    .forwardALUSrcA(forwardRs1Sel),
    .forwardALUSrcB(forwardRs2Sel)
);
*/

ForwardingUnit FWDUNIT_2(
	.MEM_rdAddr(MEM_rdAddr),
	.WB_rdAddr(WB_rdAddr),
	.EX_rs1Addr(EX_rs1Addr),
	.EX_rs2Addr(EX_rs2Addr),
	.ID_rs1Addr(ID_currInstruction[19:15]),
	.ID_rs2Addr(ID_currInstruction[24:20]),
	.ID_opCode(ID_currInstruction[6:0]),
	.MEM_reg_W_En(MEM_reg_W_EN),
	.WB_reg_W_En(WB_reg_W_EN),
	.MEM_opCode(MEM_opCode),
	.WB_opCode(WB_opCode),
	.EX_opCode(EX_opCode),
	.forwardALUSrcA(forwardRs1Sel),
	.forwardALUSrcB(forwardRs2Sel),
	.forwardRs2Src(forwardRs2ForStoreSel), /// not complete
	.forwardRFSrcA(ID_rfRs1Sel),
	.forwardRFSrcB(ID_rfRs2Sel)
);


HazardDetector HAZARD_DETECTOR(
    .EX_memReadEnable(EX_memReadEnableAfteFlush),
    .EX_rdAddr(EX_destRegAddr),
    .ID_rs1Addr(ID_currInstruction[19:15]),
    .ID_rs2Addr(ID_currInstruction[24:20]),
    .ID_opCode_I(ID_currInstruction[6:0]),
    .branch_I(MEM_branchTaken&MEM_branchInst),
    .IF_pcWriteEnable(IF_pcEnable),
    .IF_ID_pipelineRegisterEnable(IF_ID_registerEnable),
    .ID_EX_pipelineRegisterEnable(ID_EX_enable),
	.ID_bubbleSelect(ID_bubbleSelect),
    .EX_bubbleSelect(EX_bubbleSelect),
    .IF_flush(IF_flushSignal)
);

binary2SevenSegmentDecoder B2SS0(
	.bin_I(x2_data[3:0]),
	.ss_O(sevenSegDisplay[6:0])
);

binary2SevenSegmentDecoder B2SS1(
	.bin_I(x2_data[7:4]),
	.ss_O(sevenSegDisplay[13:7])
);

binary2SevenSegmentDecoder B2SS2(
	.bin_I(x2_data[11:8]),
	.ss_O(sevenSegDisplay[20:14])
);

binary2SevenSegmentDecoder B2SS3(
	.bin_I(x2_data[15:12]),
	.ss_O(sevenSegDisplay[27:21])
);

binary2SevenSegmentDecoder B2SS4(
	.bin_I(x2_data[19:16]),
	.ss_O(sevenSegDisplay[34:28])
);

binary2SevenSegmentDecoder B2SS5(
	.bin_I(x2_data[23:20]),
	.ss_O(sevenSegDisplay[41:35])
);

endmodule
