module MEM_WB_register(
    input wire clk_I,
    input wire reset_I,
    input wire enable_I,
    input wire [31:0]  memReadData_I_D,
    input wire [31:0] aluResult_I_D,
    input wire reg_W_EN_I_D,
    input wire [1:0] destRegWriteSel_I_D,
    input wire [31:0] currInstructionAddrPlus4_I_D,
    input wire [31:0] imm_I_D,
    input wire [4:0] rdAddr_I_D,
    input wire [6:0] opCode_I_D,
    output reg [31:0] memReadData_O_Q,
    output reg [31:0] aluResult_O_Q,
    output reg reg_W_EN_O_Q,
    output reg [1:0] destRegWriteSel_O_Q,
    output reg [31:0] currInstructionAddrPlus4_O_Q,
    output reg [31:0] imm_O_Q,
    output reg [4:0] rdAddr_O_Q,
    output reg [6:0] opCode_O_Q
);
always@(posedge clk_I or negedge reset_I) begin
    if(!reset_I) begin
        memReadData_O_Q <= 0;
        aluResult_O_Q <= 0;
        reg_W_EN_O_Q <= 0;
        destRegWriteSel_O_Q <= 0;
        currInstructionAddrPlus4_O_Q <= 0;
        imm_O_Q <= 0;
        rdAddr_O_Q <= 0;
        opCode_O_Q <= 0;
    end
    else begin
        if(enable_I) begin
            memReadData_O_Q <= memReadData_I_D;
            aluResult_O_Q <= aluResult_I_D;
            reg_W_EN_O_Q <= reg_W_EN_I_D;
            destRegWriteSel_O_Q <= destRegWriteSel_I_D;
            currInstructionAddrPlus4_O_Q <= currInstructionAddrPlus4_I_D;
            imm_O_Q <= imm_I_D;
            rdAddr_O_Q <= rdAddr_I_D;
            opCode_O_Q <= opCode_I_D;
        end
    end
end
endmodule 
