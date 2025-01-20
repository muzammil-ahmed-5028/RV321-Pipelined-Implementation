module insts_ROM(
	input wire [29:0] inst_addr,
	output reg [31:0] inst
);
always@(*) begin
	case({2'b00,inst_addr})
		32'h00000000: inst = 32'h00000013
;		32'h00000001: inst = 32'h00000013
;		32'h00000002: inst = 32'h00000293
;		32'h00000003: inst = 32'h00100313
;		32'h00000004: inst = 32'h006282B3
;		32'h00000005: inst = 32'h00028333
;		32'h00000006: inst = 32'hFE029CE3
;		32'h00000007: inst = 32'h00000013
;		32'h00000008: inst = 32'h00000013
;		default: inst = 32'h00000000;
	endcase
end
endmodule
