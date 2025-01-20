module EX_MEM_register (
    input wire clk_I,
    input wire reset_I,
    input wire enable_I,
    // datapath signals input
    input wire [31:0] aluResult_I_D,
    input wire [31:0] rs2Data_I_D,
    input wire [2:0] func3_I_D,
    input wire [31:0] currInstructionAddrPlus4_I_D,
    input wire [31:0] imm_I_D,
    input wire [4:0] rdAddr_I_D,
    // Control Path signals
    input wire branchTaken_I_D,
    input wire branchTypeInst_I_D,
    input wire [1:0] destRegWriteSel_I_D,
    input wire  memWriteEn_I_D,
    input wire reg_W_En_I_D,
    input wire [6:0] opCode_I_D,
    input wire memReadEnable_I_D,
    // datapath signals output
    output reg [31:0] aluResult_O_Q,
    output reg [31:0] rs2Data_O_Q,
    output reg [2:0] func3_O_Q,
    output reg [31:0] currInstructionAddrPlus4_O_Q,
    output reg [31:0] imm_O_Q,
    output reg [4:0] rdAddr_O_Q,
    // Control Path signals
    output reg branchTaken_O_Q,
    output reg branchTypeInst_O_Q,
    output reg [1:0] destRegWriteSel_O_Q,
    output reg memWriteEn_O_Q,
    output reg reg_W_En_O_Q,
    output reg [6:0] opCode_O_Q,
    output reg memReadEnable_O_Q
);

always@(posedge clk_I or negedge reset_I) begin
    if(!reset_I) begin
        aluResult_O_Q <= 0;
        rs2Data_O_Q <= 0;
        func3_O_Q <= 0;
        currInstructionAddrPlus4_O_Q <= 0;
        imm_O_Q <= 0;
        branchTaken_O_Q <= 0;
        branchTypeInst_O_Q <= 0;
        destRegWriteSel_O_Q <= 0;
        memWriteEn_O_Q <= 0;
        reg_W_En_O_Q <= 0;
        rdAddr_O_Q <= 0;
        opCode_O_Q <= 0;
        memReadEnable_O_Q<=0;
    end
    else begin
        if(enable_I) begin
            aluResult_O_Q <= aluResult_I_D;
            rs2Data_O_Q <= rs2Data_I_D;
            func3_O_Q <= func3_I_D;
            currInstructionAddrPlus4_O_Q <= currInstructionAddrPlus4_I_D;
            imm_O_Q <= imm_I_D;
            branchTaken_O_Q <= branchTaken_I_D;
            branchTypeInst_O_Q <= branchTypeInst_I_D;
            destRegWriteSel_O_Q <= destRegWriteSel_I_D;
            memWriteEn_O_Q <= memWriteEn_I_D;
            reg_W_En_O_Q <= reg_W_En_I_D;
            rdAddr_O_Q <= rdAddr_I_D;
            opCode_O_Q <= opCode_I_D;
            memReadEnable_O_Q <= memReadEnable_I_D;
        end
    end
end


endmodule
