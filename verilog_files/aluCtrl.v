module aluCtrl(
    input wire [2:0] func3_I,
    input wire [6:0] func7_I,
    input wire aluOp_I,
    input wire Itype_I,
    output reg [3:0] aluFunc_O
);
reg [3:0] RtypeFunc;

always@(*) begin
    case (func3_I)
        3'b000: RtypeFunc = (func7_I[5] & ~Itype_I) ? 4'b0001  : 4'b0000;
        3'b001: RtypeFunc = 4'b0010;
        3'b010: RtypeFunc = 4'b1000;
        3'b011: RtypeFunc = 4'b1001;
        3'b100: RtypeFunc = 4'b0111;
        3'b101: RtypeFunc = func7_I[5] ? 4'b0011 : 4'b0100;
        3'b110: RtypeFunc = 4'b0110;
        3'b111: RtypeFunc = 4'b0101;
    endcase
    aluFunc_O = aluOp_I ? RtypeFunc : 4'b0000;
end


endmodule
