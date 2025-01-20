module ID_EX_register (
    //data path input signals
    input wire clk_I,
    input wire reset_I,
    input wire enable_I,
    input wire [31:0] ID_EX_rs1_I_D,// used in EX stage
    input wire [31:0] ID_EX_rs2_I_D, // used in EX stage
    input wire [31:0] imm_I_D, // used in EX stage
    input wire [2:0] func3_I_D, // used in EX stage and in Mem Stage
    input wire [6:0] func7_I_D, // used in EX stage
    input wire [4:0] ID_EX_rdAddr_I_D, // used in WB stage will be stored further
    input wire [31:0] currInstructionAddrPlus4_I_D,
    // control input signals
    input wire reg_W_EN_I_D, // used in WB stage store till later
    input wire aluSrcB_I_D, // used in EX stage
    input wire aluSrcA_I_D, // used in EX stage
    input wire aluOp_I_D, // used in EX stage
    input wire memWriteEn_I_D, // used in MEM stage will be stored further
    input wire branchInst_I_D, // used in MEM stage will be stored further
    input wire ItypeInsts_I_D, // used in EX stage
    input wire jumpTypeInst_I_D, // used in EX stage
    input wire [1:0] destRegWriteSel_I_D, // used in WB stage 
    input wire [6:0] opCode_I_D,
    input wire [4:0] rs1Addr_I_D,
    input wire [4:0] rs2Addr_I_D,
    input wire memReadEnable_I_D,
    // data path output signals
    output reg [31:0] ID_EX_rs1_O_Q,
    output reg [31:0] ID_EX_rs2_O_Q,
    output reg [31:0] imm_O_Q,
    output reg [31:0] currInstructionAddrPlus4_O_Q,
    output reg [2:0] func3_O_Q,
    output reg [6:0] func7_O_Q,
    output reg [4:0] ID_EX_rdAddr_O_Q,
    // control input signals
    output reg reg_W_EN_O_Q,
    output reg aluSrcB_O_Q,
    output reg aluSrcA_O_Q,
    output reg aluOp_O_Q,
    output reg memWriteEn_O_Q,
    output reg branchInst_O_Q,
    output reg ItypeInsts_O_Q,
    output reg jumpTypeInst_O_Q,
    output reg [1:0] destRegWriteSel_O_Q,
    output reg [6:0] opCode_O_Q,
    output reg [4:0] rs1Addr_O_Q,
    output reg [4:0] rs2Addr_O_Q,
    output reg memReadEnable_O_Q
);

always@(posedge clk_I or negedge reset_I) begin
    if(!reset_I) begin
        ID_EX_rs1_O_Q <= 0;
        ID_EX_rs2_O_Q <= 0;
        imm_O_Q <= 0;
        func3_O_Q <= 0;
        func7_O_Q <= 0;
        ID_EX_rdAddr_O_Q <= 0;
        currInstructionAddrPlus4_O_Q <= 0;
        // control input signals
        reg_W_EN_O_Q <= 0;
        aluSrcB_O_Q <= 0;
        aluSrcA_O_Q <= 0;
        aluOp_O_Q <= 0;
        memWriteEn_O_Q <= 0;
        branchInst_O_Q <= 0;
        ItypeInsts_O_Q <= 0;
        jumpTypeInst_O_Q <= 0;
        destRegWriteSel_O_Q <= 0;
        opCode_O_Q <= 0;
        rs1Addr_O_Q<= 0;
        rs2Addr_O_Q<= 0;
        memReadEnable_O_Q <= 0;
    end
    else begin
        if (enable_I) begin
            ID_EX_rs1_O_Q <= ID_EX_rs1_I_D;
            ID_EX_rs2_O_Q <= ID_EX_rs2_I_D;
            imm_O_Q <= imm_I_D;
            func3_O_Q <= func3_I_D;
            func7_O_Q <= func7_I_D;
            ID_EX_rdAddr_O_Q <= ID_EX_rdAddr_I_D;
            currInstructionAddrPlus4_O_Q <= currInstructionAddrPlus4_I_D;
            // control input signals
            reg_W_EN_O_Q <= reg_W_EN_I_D;
            aluSrcB_O_Q <= aluSrcB_I_D;
            aluSrcA_O_Q <= aluSrcA_I_D;
            aluOp_O_Q <= aluOp_I_D;
            memWriteEn_O_Q <= memWriteEn_I_D;
            branchInst_O_Q <= branchInst_I_D;
            ItypeInsts_O_Q <= ItypeInsts_I_D;
            jumpTypeInst_O_Q <= jumpTypeInst_I_D;
            destRegWriteSel_O_Q <= destRegWriteSel_I_D;
            opCode_O_Q <= opCode_I_D;
            rs1Addr_O_Q <= rs1Addr_I_D;
            rs2Addr_O_Q <= rs2Addr_I_D;
            memReadEnable_O_Q <= memReadEnable_I_D;
        end
    end
end


endmodule
