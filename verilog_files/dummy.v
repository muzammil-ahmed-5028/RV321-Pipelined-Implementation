
dff DFF(
	.D()	 \\ signal length = 32,
	.clk()	 \\ signal length = 1 ,
	.reset()	 \\ signal length = 1 ,
	.enable()	 \\ signal length = 1 ,
	.Q()	 \\ signal length = 32,
);

four_adder FOUR_ADDER(
	.B_I()	 \\ signal length = 32,
	.C_O()	 \\ signal length = 32,
);

inst_mem INST_MEM(
	.instAddr_I()	 \\ signal length = 32,
	.instruction_O()	 \\ signal length = 32,
);

IF_ID_Register IF_ID_REGISTER(
	.pcAddr_D_I()	 \\ signal length = 32,
	.currInstruction_D_I()	 \\ signal length = 32,
	.currInstructionAddrPlus4_D_I()	 \\ signal length = 32,
	.clk_I()	 \\ signal length = 1 ,
	.reset_I()	 \\ signal length = 1 ,
	.enable_I()	 \\ signal length = 1 ,
	.pcAddr_Q_O()	 \\ signal length = 32,
	.currInstruction_Q_O()	 \\ signal length = 32,
	.currInstructionAddrPlus4_Q_O()	 \\ signal length = 32,
);

control CONTROL(
	.opCode_I()	 \\ signal length = 1 ,
	.reg_W_EN_O()	 \\ signal length = 1 ,
	.aluSrcB_O()	 \\ signal length = 1 ,
	.aluSrcA_O()	 \\ signal length = 1 ,
	.aluOp_O()	 \\ signal length = 1 ,
	.memWriteEn_O()	 \\ signal length = 1 ,
	.branchInst_O()	 \\ signal length = 1 ,
	.ItypeInsts_O()	 \\ signal length = 1 ,
	.jumpTypeInst_O()	 \\ signal length = 1 ,
	.destRegWriteSel_O()	 \\ signal length = 2,
);

regfile REGFILE(
	.clk_I()	 \\ signal length = 1 ,
	.w_en_I()	 \\ signal length = 1 ,
	.r_en_I()	 \\ signal length = 1 ,
	.addrRegA_I()	 \\ signal length = 5,
	.addrRegB_I()	 \\ signal length = 5,
	.destReg_I()	 \\ signal length = 5,
	.destRegWrite_I()	 \\ signal length = 32,
	.dataRegA_O()	 \\ signal length = 32,
	.dataRegB_O()	 \\ signal length = 32,
);

immGen IMMGEN(
	.instruction_I()	 \\ signal length = 32,
	.imm_O()	 \\ signal length = 32,
);

ID_EX_register ID_EX_REGISTER(
	.input()	 \\ signal length = 1 ,
	.clk_I()	 \\ signal length = 1 ,
	.reset_I()	 \\ signal length = 1 ,
	.enable_I()	 \\ signal length = 1 ,
	.ID_EX_rs1_I_D//()	 \\ signal length = 32,
	.ID_EX_rs2_I_D()	 \\ signal length = 32,
	.imm_I_D()	 \\ signal length = 32,
	.func3_I_D()	 \\ signal length = 3,
	.func7_I_D()	 \\ signal length = 7,
	.ID_EX_rdAddr_I_D()	 \\ signal length = 5,
	.currInstructionAddrPlus4_I_D()	 \\ signal length = 32,
	.input()	 \\ signal length = 1 ,
	.reg_W_EN_I_D()	 \\ signal length = 1 ,
	.aluSrcB_I_D()	 \\ signal length = 1 ,
	.aluSrcA_I_D()	 \\ signal length = 1 ,
	.aluOp_I_D()	 \\ signal length = 1 ,
	.memWriteEn_I_D()	 \\ signal length = 1 ,
	.branchInst_I_D()	 \\ signal length = 1 ,
	.ItypeInsts_I_D()	 \\ signal length = 1 ,
	.jumpTypeInst_I_D()	 \\ signal length = 1 ,
	.destRegWriteSel_I_D()	 \\ signal length = 2,
	.path()	 \\ signal length = 1 ,
	.ID_EX_rs1_O_Q()	 \\ signal length = 32,
	.ID_EX_rs2_O_Q()	 \\ signal length = 32,
	.imm_O_Q()	 \\ signal length = 32,
	.currInstructionAddrPlus4_O_Q()	 \\ signal length = 32,
	.func3_O_Q()	 \\ signal length = 3,
	.func7_O_Q()	 \\ signal length = 7,
	.ID_EX_rdAddr_O_Q()	 \\ signal length = 5,
	.input()	 \\ signal length = 1 ,
	.reg_W_EN_O_Q()	 \\ signal length = 1 ,
	.aluSrcB_O_Q()	 \\ signal length = 1 ,
	.aluSrcA_O_Q()	 \\ signal length = 1 ,
	.aluOp_O_Q()	 \\ signal length = 1 ,
	.memWriteEn_O_Q()	 \\ signal length = 1 ,
	.branchInst_O_Q()	 \\ signal length = 1 ,
	.ItypeInsts_O_Q()	 \\ signal length = 1 ,
	.jumpTypeInst_O_Q()	 \\ signal length = 1 ,
	.destRegWriteSel_O_Q()	 \\ signal length = 2,
);

ALU ALU(
	.regA_I()	 \\ signal length = 32,
	.regB_I()	 \\ signal length = 32,
	.aluOP_I()	 \\ signal length = 4,
	.result_O()	 \\ signal length = 32,
);

aluCtrl ALUCTRL(
	.func3_I()	 \\ signal length = 3,
	.func7_I()	 \\ signal length = 7,
	.aluOp_I()	 \\ signal length = 1 ,
	.Itype_I()	 \\ signal length = 1 ,
	.aluFunc_O()	 \\ signal length = 4,
);

branchDecide BRANCHDECIDE(
	.rs1Data()	 \\ signal length = 32,
	.rs2Data()	 \\ signal length = 32,
	.func3()	 \\ signal length = 3,
	.jumpTypeInstFlag()	 \\ signal length = 1 ,
	.branchTaken()	 \\ signal length = 1 ,
);

EX_MEM_register EX_MEM_REGISTER(
	.clk_I()	 \\ signal length = 1 ,
	.reset_I()	 \\ signal length = 1 ,
	.enable_I()	 \\ signal length = 1 ,
	.signals()	 \\ signal length = 1 ,
	.aluResult_I_D()	 \\ signal length = 32,
	.rs2Data_I_D()	 \\ signal length = 32,
	.func3_I_D()	 \\ signal length = 3,
	.currInstructionAddrPlus4_I_D()	 \\ signal length = 32,
	.imm_I_D()	 \\ signal length = 32,
	.Path()	 \\ signal length = 1 ,
	.branchTaken_I_D()	 \\ signal length = 1 ,
	.branchTypeInst_I_D()	 \\ signal length = 1 ,
	.destRegWriteSel_I_D()	 \\ signal length = 2,
	.memWriteEn_I_D()	 \\ signal length = 3,
	.reg_W_En_I_D()	 \\ signal length = 1 ,
	.signals()	 \\ signal length = 1 ,
	.aluResult_O_Q()	 \\ signal length = 32,
	.rs2Data_O_Q()	 \\ signal length = 32,
	.func3_O_Q()	 \\ signal length = 3,
	.currInstructionAddrPlus4_O_Q()	 \\ signal length = 32,
	.imm_O_Q()	 \\ signal length = 32,
	.Path()	 \\ signal length = 1 ,
	.branchTaken_O_Q()	 \\ signal length = 1 ,
	.branchTypeInst_O_Q()	 \\ signal length = 1 ,
	.destRegWriteSel_O_Q()	 \\ signal length = 2,
	.memWriteEn_O_Q()	 \\ signal length = 3,
	.reg_W_En_O_Q()	 \\ signal length = 1 ,
);

dataMem DATAMEM(
	.address_I()	 \\ signal length = 32,
	.wrData_I()	 \\ signal length = 32,
	.memReadSel_I()	 \\ signal length = 3,
	.memWriteEn_I()	 \\ signal length = 1 ,
	.clk()	 \\ signal length = 1 ,
	.reData()	 \\ signal length = 32,
);

MEM_WB_register MEM_WB_REGISTER(
	.clk_I()	 \\ signal length = 1 ,
	.reset_I()	 \\ signal length = 1 ,
	.enable_I()	 \\ signal length = 1 ,
	.memReadData_I_D()	 \\ signal length = 32,
	.aluResult_I_D()	 \\ signal length = 32,
	.reg_W_EN_I_D()	 \\ signal length = 1 ,
	.destRegWriteSel_I_D()	 \\ signal length = 2,
	.currInstructionAddrPlus4_I_D()	 \\ signal length = 32,
	.imm_I_D()	 \\ signal length = 32,
	.memReadData_O_Q()	 \\ signal length = 32,
	.aluResult_O_Q()	 \\ signal length = 32,
	.reg_W_EN_O_Q()	 \\ signal length = 1 ,
	.destRegWriteSel_O_Q()	 \\ signal length = 2,
	.currInstructionAddrPlus4_O_Q()	 \\ signal length = 32,
	.imm_O_Q()	 \\ signal length = 32,
);

