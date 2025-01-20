module branchDecide(
    input wire [31:0] rs1Data,
    input wire [31:0] rs2Data,
    input wire [2:0] func3,
    input wire jumpTypeInstFlag,
    output reg branchTaken
);
always@(*) begin
    case(jumpTypeInstFlag) 
        1'b0: begin
        case(func3)
            3'b000: branchTaken = ($signed(rs1Data) == $signed(rs2Data));
            3'b001: branchTaken = ($signed(rs1Data) != $signed(rs2Data));
            3'b100: branchTaken = ($signed(rs1Data) <  $signed(rs2Data));
            3'b101: branchTaken = ($signed(rs1Data) >= $signed(rs2Data));
            3'b110: branchTaken = ($unsigned(rs1Data) <  $unsigned(rs2Data));
            3'b111: branchTaken = ($unsigned(rs1Data) >= $unsigned(rs2Data));
            default: branchTaken = 1'b0;
        endcase
        end
        1'b1:branchTaken = 1'b1;
        default: branchTaken = 1'b0;
endcase
end
endmodule
