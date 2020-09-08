print('Running Assembler:')

#fileObj = open("filename", "mode") 
filename = "Assembly2.txt"

read_file = open(filename, "r") 

#Print read_file

#w_file is the file we are writing to

w_file = open("Machine2.txt", "w")


#Open a file name and read each line
#to strip \n newline chars
#lines = [line.rstrip('\n') for line in open('filename')]  

#1. open the file
#2. for each line in the file,
#3.     split the string by white spaces
#4.      if the first string == SET then op3 = 0, else op3 = 1
#5.      
with open(filename, 'r') as f:
  for line in f:
    print(line)
    str_array = line.split()
    instruction = str_array[0]

    print(instruction)
    print(str_array)

    if instruction == "SET":
      op3 = "1"
      imm = str_array[1]  #need to reformat without the hashtag
      bin_imm = '{0:08b}'.format(int(imm)) #8 bit immediate
      #str_array[2] should be the comment
      return_set = op3 + bin_imm #+ '\t' + "#" + " " + instruction + " " + imm 
      w_file.write(return_set + '\n')
    else:
      op3 = "0"            

      if instruction == "END":
        opcode = "0000"
        reg1 = "00"
        reg2 = "00"
        op1 = "" 	
        op2 = ""	
      elif instruction == "MOV":
        opcode = "0001"
        op1 = str_array[1] 	
        op2 = str_array[2]
      elif instruction == "LFS":
        opcode = "0010"
        op1 = str_array[1] 	
        op2 = str_array[2]
      elif instruction == "ADD":
        opcode = "0011"
        op1 = str_array[1] 	
        op2 = str_array[2]
      elif instruction == "SUB":
        opcode = "0100" 
        op1 = str_array[1] 	
        op2 = str_array[2]
      elif instruction == "XOR": 
        opcode = "0101"
        op1 = str_array[1]
        op2 = str_array[2] 	
      elif instruction == "CMP":
        opcode = "0110"
        op1 = str_array[1]
        op2 = str_array[2]
      elif instruction == "PAR":
        opcode = "0111" 
        op1 = str_array[1]
        op2 = "000"       
      elif instruction == "BNE":
        opcode = "1001"
        reg1 = str_array[1]
        reg2 = ""
        op1 = str_array[1]
        op2 = "000"
      elif instruction == "BLT":
        opcode = "1010"
        reg1 = str_array[1]
        reg2 = ""
        op1 = str_array[1]
        op2 = "000"
      elif instruction == "BGT":
        opcode = "1011"
        reg1 = str_array[1]
        reg2 = ""
        op1 = str_array[1]
        op2 = "000"
      elif instruction == "LDR":
        opcode = "1100"
        op1 = str_array[1] 	
        op2 = str_array[2]
      elif instruction == "STR":
        opcode = "1101"
        op1 = str_array[1] 	
        op2 = str_array[2]
      else:
        opcode = "error: undefined opcode"
        print("error: undefined opcode")
    
      print(op1)

      if (op1 == "r0,"):
        reg1 = "00"
      elif (op1 == "r1,"):
        reg1 = "01"
      elif (op1 == "r2,"):
        reg1 = "10"
      elif (op1 == "r3,"):
        reg1 = "11"

      if (op2 == "r0"):
        reg2 = "00"
      elif (op2 == "r1"):
        reg2 = "01"
      elif (op2 == "r2"):
        reg2 = "10"
      elif (op2 == "r3"):
        reg2 = "11"
      
      if op2 == "000":
        return_rtype = op3 + opcode + reg1 + reg2 #+ '\t' + "#" + " " + instruction + " " + op1 
      else:
        return_rtype = op3 + opcode + reg1 + reg2 #+ '\t' + "#" + " " + instruction 	+ " " + op1 + " " + op2
        

      w_file.write(return_rtype + '\n' )



w_file.close()
   

      


