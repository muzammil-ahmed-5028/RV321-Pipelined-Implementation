module inst_mem(
    input wire [31:0] instAddr_I,
    output wire [31:0] instruction_O
);
reg [31:0] instructions [1023:0];
initial $readmemh("insts.mem",instructions);
assign instruction_O = instructions[instAddr_I[31:2]];
endmodule
