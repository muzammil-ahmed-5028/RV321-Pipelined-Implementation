module four_adder(
    input wire [31:0]  B_I,
    output wire [31:0]  C_O
);
assign C_O = B_I + 32'h00000004;
endmodule
