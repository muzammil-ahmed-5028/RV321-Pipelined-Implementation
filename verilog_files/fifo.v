module fifo(
    input wire [8:0] data_I,
    input wire new_data_I,
    input wire clk_I,
    input wire reset_I,
    output reg [8:0] pop_data
);
reg [8:0] registers [31:0];
integer i;
reg [5:0] fifo_top_pointer;
always@(posedge clk_I or negedge reset_I) begin
    if(!reset_I) begin
        for (i=0;i<32;i = i +1) begin
            registers[i] <= 0;
            pop_data <= registers[0];
            fifo_top_pointer <= 5'b00000;
        end
    end
    else begin
        if(new_data_I) begin
            if (fifo_top_pointer == 5'b11111) begin
                fifo_top_pointer <= 5'b11111;
                pop_data <= registers[fifo_top_pointer];
            end
            else begin
                fifo_top_pointer = fifo_top_pointer + 1;
                pop_data <= registers[fifo_top_pointer];
            end
            for(i=0;i<fifo_top_pointer;i=i+1) begin
                registers[i+1] <= registers[i];
            end
            registers[0] <= data_I;
        end
    end
end
endmodule
