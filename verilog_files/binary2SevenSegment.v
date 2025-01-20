module binary2SevenSegmentDecoder(
    input wire [3:0] bin_I,
    output reg [6:0] ss_O
);
// the module is active low
// ss_O[0] corresponds to 0 according to de1-soc manual
always@(*) begin
    case(bin_I) //         6543210
        4'b0000: ss_O = 7'b1000000;//  0
        4'b0001: ss_O = 7'b1111001;// 1
        4'b0010: ss_O = 7'b0100100;// 2
        4'b0011: ss_O = 7'b0110000;// 3
        4'b0100: ss_O = 7'b0001101;// 4
        4'b0101: ss_O = 7'b0010010;// 5
        4'b0110: ss_O = 7'b0000010;// 6
        4'b0111: ss_O = 7'b1111000;// 7
        4'b1000: ss_O = 7'b0000000;// 8
        4'b1001: ss_O = 7'b0010000;// 9
        4'b1010: ss_O = 7'b0001000;// 10 A
        4'b1011: ss_O = 7'b0000011;// 11 B
        4'b1100: ss_O = 7'b1000110;// 12 C
        4'b1101: ss_O = 7'b0100001;// 13 D
        4'b1110: ss_O = 7'b1000110;// 14 E
        4'b1111: ss_O = 7'b0001110;// 15 F
        default: ss_O = 7'b0101101;// default weird symbol
    endcase
end
endmodule
