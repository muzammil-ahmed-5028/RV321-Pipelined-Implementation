path = '/home/muzammilahmed5028/codes/python'
newFileName = 'top_module_pipielined.v'
newfile = open(newFileName,"w")
newfile.write('\n')
filelist = [
'dff.v',
'4-bit-adder.v',
'instmem.v',
'IF_ID_Register.v',
'control.v',
'regfile.v',
'immGen.v',
'ID_EX_register.v',
'ALU.v',
'aluCtrl.v',
'branchDecider.v',
'EX_MEM_register.v',
'dataMEM.v',
'MEM_WB_register.v'
]
for i in filelist:
    curr_file = open(i,"r")
    data = curr_file.readlines()
    data_parts = data[0].split()
    newfile.write(f"{data_parts[1]} ".replace('(',"") + (f"{data_parts[1]}".replace('(','')).upper() + "(\n")
    found = 0
    line_iterator = 1
    while found == 0:
        if data[line_iterator] == ");\n":
            found = 1
            newfile.write(");\n")
        else:
            curr_data_parts = data[line_iterator].split()
            print(curr_data_parts)
            if len(curr_data_parts) != 0 and curr_data_parts[0][0] != "\\":
                if curr_data_parts[2][0] == "[":
                    ## add code to add length of block
                    curr_character = ""
                    character_iterator = 0
                    length_of_signal = ""
                    while curr_character != ":":
                        curr_character = curr_data_parts[2][character_iterator]
                        length_of_signal += curr_character
                        character_iterator += 1
                    length_of_signal = length_of_signal.replace('[',"").replace(':',"")
                    length_of_signal = int(length_of_signal,10) + 1
                    newfile.write(f'\t.{curr_data_parts[3]}()'.replace(",","") + f",\t // signal length = {length_of_signal}" + "\n")
                else:
                    newfile.write(f'\t.{curr_data_parts[2]}()'.replace(",","") + f",\t // signal length = 1 " + "\n")
            line_iterator += 1
    newfile.write('\n')

newfile.close()

