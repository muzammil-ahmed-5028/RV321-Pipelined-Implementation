module immGen(
    input wire [31:0] instruction_I,
    output wire [31:0] imm_O
);

// instruction select bit[0] = B | A ^ D
// instruction select bit[1] = (A & ~D) | (~A & B & ~C)
// instruction select bit[2] = D
// A = opcode bit 6
// B = opcode[5]
// C = opcode[4]
// D = opcode[2]

wire [6:0]  opCode = instruction_I[6:0];
wire [2:0] instSel;
reg [31:0] immIntermediate;
assign instSel[0] = ~opCode[5] | ( opCode[6] & ~opCode[2]) | (~opCode[6] & opCode[2]) ;
assign instSel[1] = (opCode[6] & ~opCode[2]) | (~opCode[6] & opCode[5] & ~opCode[4]);
assign instSel[2] = opCode[2];

always@(*) begin
    case(instSel)
        3'b001: begin // I type
            immIntermediate[0]  = instruction_I[20];
            immIntermediate[4:1] = instruction_I[24:21];
            immIntermediate[10:5] = instruction_I[30:25];
            immIntermediate[31:11] = {21{instruction_I[31]}};
        end
        3'b010: begin // Store
            immIntermediate[0]  = instruction_I[7];
            immIntermediate[4:1] = instruction_I[11:8];
            immIntermediate[10:5] = instruction_I[30:25];
            immIntermediate[31:11] = {21{instruction_I[31]}};
        end
        3'b011: begin // branch
            immIntermediate[0]  = 1'b0;
            immIntermediate[4:1] = instruction_I[11:8];
            immIntermediate[10:5] = instruction_I[30:25];
            immIntermediate[11] = instruction_I[7];
            immIntermediate[31:12] = {20{instruction_I[31]}};
        end
        3'b100: begin // jump 
            immIntermediate[0]  = 1'b0;
            immIntermediate[4:1] = instruction_I[24:21];
            immIntermediate[10:5] = instruction_I[30:25];
            immIntermediate[11] = instruction_I[20];
            immIntermediate[19:12] = instruction_I[19:12];
            immIntermediate[31:20] = {12{instruction_I[31]}};
        end
        3'b101: begin // Utype 
            immIntermediate[11:0]  = 12'b0;
            immIntermediate[20:12] = instruction_I[20:12];
            immIntermediate[31:21] = instruction_I[30:21];
        end
        default: immIntermediate = 32'h00000000;
    endcase
end

assign imm_O = immIntermediate;

endmodule
