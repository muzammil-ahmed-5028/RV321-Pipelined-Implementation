module top_tb;
reg clk = 1'b1;
reg reset = 1'b1;
wire [41:0] sevenSegDisp;

top_pipelined dut(
    .clk_I(clk),
    .reset_I(reset),
    .sevenSegDisplay(sevenSegDisp)
);

always #5 clk = ~clk;

initial begin
    $dumpfile("01.vcd");
    $dumpvars(0,top_tb);
    reset = 1'b1; #5
    reset = 1'b0; #5
    reset = 1'b1; #5
    #3000
    $stop;
    $finish;
end
endmodule

