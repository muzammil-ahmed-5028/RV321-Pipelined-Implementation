file_name = "insts_fpga.mem"
rom_file_name = "insts_rom.v"
inst_file = open(file_name,'r')
rom_file = open(rom_file_name,'w')
## getting info from instruction file for further processing
instructions = []
for line in inst_file:
    instructions.append(line[2:])

rom_file.write("module insts_ROM(\n")
rom_file.write("\tinput wire [29:0] inst_addr,\n")
rom_file.write("\toutput reg [31:0] inst\n")
rom_file.write(");\n")
## module Code here
rom_file.write("always@(*) begin\n")
#start of always block
rom_file.write("\tcase({2'b00,inst_addr})\n")
#start of case statement
for i in range(len(instructions)):
    rom_file.write(f"\t\t32'h{i:08x}: inst = 32'h{instructions[i] + ';'}")
rom_file.write("\t\tdefault: inst = 32'h00000000;\n")
#end of case statement
rom_file.write("\tendcase\n")
#end of always block
rom_file.write("end\n")
#end of module code
rom_file.write("endmodule\n")

