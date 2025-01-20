module ALU(
    input wire [31:0] regA_I,
    input wire [31:0] regB_I,
    input wire [3:0] aluOP_I,
    output reg [31:0] result_O
);

wire [31:0] sum;
wire [31:0] diff;
wire [31:0] sll;
wire [31:0] sra;
wire [31:0] srl;
wire [31:0] and_bitwise;
wire [31:0] or_bitwise;
wire [31:0] xor_bitwise;
wire [31:0] xnor_bitwise;

assign sum = $signed(regA_I) + $signed(regB_I);
assign diff = $signed(regA_I) - $signed(regB_I);
assign sll = (regA_I) << (regB_I[4:0]);
assign sra = $signed(regA_I) >>> $signed(regB_I[4:0]);
assign srl = (regA_I) >> (regB_I[4:0]);
assign and_bitwise = (regA_I) &  (regB_I);
assign or_bitwise = (regA_I) | (regB_I);
assign xor_bitwise = (regA_I) ^ (regB_I);

always@(*) begin
    case (aluOP_I)
        4'b0000: result_O = sum;
        4'b0001: result_O = diff;
        4'b0010: result_O = sll;
        4'b0011: result_O = sra;
        4'b0100: result_O = srl;
        4'b0101: result_O = and_bitwise;
        4'b0110: result_O = or_bitwise;
        4'b0111: result_O = xor_bitwise;
        4'b1000: result_O = ($signed(regA_I) < $signed(regB_I));
        4'b1001: result_O = (regA_I < regB_I);
        default: result_O = 32'h00000000;
    endcase
end
endmodule
