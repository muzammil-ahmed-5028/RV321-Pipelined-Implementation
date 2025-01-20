module HazardDetector(
    input wire EX_memReadEnable,
    input wire [4:0] EX_rdAddr,
    input wire [4:0] ID_rs1Addr,
    input wire [4:0] ID_rs2Addr,
    input wire [6:0] ID_opCode_I,
    input wire branch_I,
    output reg IF_pcWriteEnable,
    output reg ID_EX_pipelineRegisterEnable,
    output reg ID_bubbleSelect,
    output reg EX_bubbleSelect,
    output reg IF_flush
);

wire regEqualFlag;
wire opCodeFlag;
assign regEqualFlag = (EX_rdAddr == ID_rs1Addr) | (EX_rdAddr == ID_rs2Addr);
assign opCodeFlag = !((ID_opCode_I == 7'b1101111) | (ID_opCode_I == 7'b0110111) | (ID_opCode_I == 7'b0010111));

always@(*) begin
    if(branch_I) begin
        IF_pcWriteEnable = 1;
        ID_EX_pipelineRegisterEnable = 1;
        ID_bubbleSelect = 1;
        EX_bubbleSelect = 1;
        IF_flush = 1;
    end
    else begin
        case(regEqualFlag & EX_memReadEnable & opCodeFlag)
            1'b1: begin
                IF_pcWriteEnable = 0;
                ID_EX_pipelineRegisterEnable = 0; //changed to 0
                ID_bubbleSelect = 1;
            end
             1'b0: begin
                IF_pcWriteEnable = 1;
                ID_EX_pipelineRegisterEnable= 1;
                ID_bubbleSelect = 0;
             end
             default: begin 
                 IF_pcWriteEnable = 1;
                 ID_EX_pipelineRegisterEnable= 1;
                 ID_bubbleSelect = 0;
             end
        endcase
        EX_bubbleSelect = 0;
        IF_flush = 0;
    end
end
endmodule


