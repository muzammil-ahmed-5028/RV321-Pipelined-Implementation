module dataMem(
    input wire [31:0] address_I,
    input wire [31:0] wrData_I,
    input wire [2:0] memReadSel_I,
    input wire memReadEnable_I,
    input wire memWriteEn_I,
    input wire clk,
    output reg [31:0] reData
    
);

reg [31:0] memory [128:0];
// read operations according to func3
wire [31:0] currMemData;
wire [15:0] currHalfWord;
reg [7:0] currByte;

assign currMemData = memory[address_I[31:2]];
assign currHalfWord = address_I[1] ? currMemData[31:16] : currMemData[15:0];
always@(*) begin
    case(address_I[1:0])
        2'b00: currByte = currMemData[7:0];
        2'b01: currByte = currMemData[15:8];
        2'b10: currByte = currMemData[23:16];
        2'b11: currByte = currMemData[31:24];
    endcase
end

always@(*) begin
    if(memReadEnable_I) begin
        case(memReadSel_I)
            3'b000: reData = {{24{currByte[7]}},currByte} ;
            3'b001: reData = {{16{currHalfWord[15]}},currHalfWord};
            3'b010: reData = currMemData;
            3'b100: reData = {{24{1'b0}},currByte};
            3'b101: reData = {{16{1'b0}},currHalfWord};
            default: reData = 32'h00000000;
        endcase
    end
end
// write operations according to func3
// func3 is directly passed to memReadSel_I
always@(posedge clk) begin
    if(memWriteEn_I) begin
        case(memReadSel_I[1:0])
            2'b00:begin
                case(address_I[1:0])
                    2'b00:memory[address_I[31:2]] <= {memory[address_I[31:2]][31:8],wrData_I[7:0]};
                    2'b01:memory[address_I[31:2]] <= {memory[address_I[31:2]][31:16],wrData_I[7:0],memory[address_I[31:2]][7:0]};
                    2'b10:memory[address_I[31:2]] <= {memory[address_I[31:2]][31:24],wrData_I[7:0],memory[address_I[31:2]][15:0]};
                    2'b11:memory[address_I[31:2]] <= {wrData_I[7:0],memory[address_I[31:2]][23:0]};
                endcase
            end
            2'b01: memory[address_I[31:2]] <= address_I[1] ? {memory[address_I[31:2]][31:16],wrData_I[15:0]} : {wrData_I[15:0],memory[address_I[31:2]][15:0]};
            2'b10: memory[address_I[31:2]] <= wrData_I;
            default: memory[address_I[31:2]] <= memory[address_I[31:2]];
        endcase
    end
end

endmodule
