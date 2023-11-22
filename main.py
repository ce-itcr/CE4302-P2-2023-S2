# ======================================================================================================
# SCRIPT NAME: main.py
#
# PURPOSE: convert Tessia v1.0.0 instructions to binary.
#
# REVISION HISTORY:
#
# AUTHOR				    DATE			    DETAILS
# --------------------- --------------- --------------------------------
# @angelortizv          2023-05-09	    Special Addressing
# 
# ======================================================================================================
import os

functionDictionary = {

    'SUMR': '0100',
    'SUMI': '0100',
    'RESR': '0010',
    'RESI': '0010',
    'MULR': '0000',
    'MULI': '0000',
    'CMPE': '1010',
    'MOVE': '1101',
    
    'BIGA': '0000100',
    'BNIA': '0001100',
    'MAQA': '1100100',
    'MEQA': '1011100',
    'AQIA': '1010100',
    'EQIA': '1101100',
    'BIGD': '0000101',
    'BNID': '0001101',
    'MAQD': '1100101',
    'MEQD': '1011101',
    'AQID': '1010101',
    'EQID': '1101101'

}

branchDictionary = {}

def romInit(wordSize, depth):

    romFile = open("src/rom_data.mif", "r+")
    romFile.truncate(0)
    
    romFile.write("--------------------- Tessia v1.0.0 ---------------------\n\n")

    romFile.write(f'WIDTH={wordSize};\nDEPTH={depth};\n \n')
    romFile.write("ADDRESS_RADIX=UNS;\nDATA_RADIX=BIN;\n \n")
    romFile.write("CONTENT BEGIN\n")
    
    counter = 0

    binaryFile = open('src/binary.txt', 'r')
    lastLine = binaryFile.readlines()[-1]
    binaryFile.seek(0)
    for instruction in binaryFile:
        romFile.write(f'\t{counter}\t :\t {instruction[:-1]};\n')
        counter += 1

    romFile.write(f'\t[{counter}..{depth-1}]\t :\t {0};\n')
    
    romFile.write("END;")
    romFile.write("\n\n--------------------- Tessia v1.0.0 ---------------------\n\n")
    romFile.close()

def reader_branches():
    counter = 0
    with open('src/file.txt', 'r') as f:
        lines = f.readlines()
        f.close()
    with open('src/newfile.txt', 'xt') as f:
        for line in lines:
            if(line[-2] == ':'):
                temp = line[:-2]
                print(temp)
                lnNum = bin(counter)[2:].zfill(24)
                branchDictionary[temp] = lnNum
            else:
                f.write(line)
                counter += 1
        f.close()
        
def reader():
    counter = 0
    with open('src/newfile.txt', 'r') as f:
        lastLine = f.readlines()[-1]
        f.seek(0)
        binaryFile = open('src/binary.txt', 'w')
        for line in f:
            if(line[0:4][3] == 'I'):
                imm = immediateAddressing(line)
                binaryFile.write(imm)
            elif (line[0:4][3] == 'R'):
                reg = registerAddressing(line)
                binaryFile.write(reg)
            elif (line[0:4][3] == 'A' or line[0:4][3] == 'D'):
                reg = branchAddressing(line, counter)
                binaryFile.write(reg)
            elif (line[0:4][3] == 'E'):
                spec = specialAddressing(line)
                binaryFile.write(spec)
            binaryFile.write('\n')
            counter += 1
        f.close()
    os.remove("src/newfile.txt")

def branchAddressing(syntax, counter):
    currentFunction = ''
    instruction = syntax[0:4]    
    if instruction in functionDictionary:
        currentFunction = functionDictionary[instruction]
    else:
        pass
    
    value = currentFunction

    if(instruction[3] == 'D'):
        tempcount = int(branchDictionary[syntax[5:-1]], 2) - counter - 2
        tempcount = tempcount * 4
        jump = bin(tempcount)[2:].zfill(57)
        value = value + jump 
    else:
        tempcount = counter + 2 - int(branchDictionary[syntax[5:-1]], 2)
        tempcount = tempcount * 4
        jump = bin(tempcount)[2:].zfill(57)
        value = value + jump
        
    
    return value

def specialAddressing(syntax):
    syntaxString = syntax[6:]
    parts = syntaxString.split(",")

    if "[" in parts[1]: 
        numbers = []

        for element in syntax[6:].split(","):
            if any(c.isdigit() for c in element):
                numbers.append(int(''.join(filter(str.isdigit, element))))
        rd = bin(numbers[0])[2:].zfill(5)
        rb = bin(numbers[1])[2:].zfill(5)
        imm = bin(numbers[2])[2:].zfill(24)

        if(syntax[0] == 'G'):
            value = '1110' + '01' + '1' + '0000' + '0' + rb + rd + ('0').zfill(18) + imm
        
        elif(syntax[0] == 'O'):
            value = '1110' + '01' + '1' + '0000' + '1' +  rb + rd + ('0').zfill(18) + imm
        
        return value
    else: 
        instruction = syntax[0:4]

        if instruction in functionDictionary:
            currentFunction = functionDictionary[instruction]
        else:
            pass

        numbers = []
        for element in syntax[6:].split(","):
            if any(c.isdigit() for c in element):
                numbers.append(int(''.join(filter(str.isdigit, element))))

        if(syntax[0] == 'M'):
            rb = bin(numbers[0])[2:].zfill(5)
            imm = bin(numbers[1])[2:].zfill(24)
            value = '1110' + '00' + '1' + currentFunction + '0' + '00000' + rb + ('0').zfill(18) + imm
        
        elif(syntax[0] == 'C'):
            rs1 = bin(numbers[0])[2:].zfill(5)
            rs2 = bin(numbers[1])[2:].zfill(5)
            value = '1110' + '00'+ '0' + '1010'+ '0' + rs1 + ('0').zfill(42) + rs2
        return value


def registerAddressing(syntax):
    instruction = syntax[0:4]
    currentFunction = ''

    if instruction in functionDictionary:
        currentFunction = functionDictionary[instruction]
    else:
        pass

    numbers = []
    for element in syntax[6:].split(","):
        if any(c.isdigit() for c in element):
            numbers.append(int(''.join(filter(str.isdigit, element))))

    rb = bin(numbers[0])[2:].zfill(5)
    rs1 = bin(numbers[1])[2:].zfill(5)
    rs2 = bin(numbers[2])[2:].zfill(5)
    
    value = '1110' + '00'+ '0' + currentFunction + '0' + rs1 + rb + ('0').zfill(37) + rs2
    return value


def immediateAddressing(syntax):
    instruction = syntax[0:4]
    currentFunction = ''
    
    if instruction in functionDictionary:
        currentFunction = functionDictionary[instruction]
    else:
        pass

    numbers = []
    for element in syntax[6:].split(","):
        if any(c.isdigit() for c in element):
            numbers.append(int(''.join(filter(str.isdigit, element))))

    rd = bin(numbers[0])[2:].zfill(5)
    rb = bin(numbers[1])[2:].zfill(5)
    imm = bin(numbers[2])[2:].zfill(24)

    value = '1110' + '00'+ '1' + currentFunction + '0' + rb + rd + ('0').zfill(18) + imm
    return value
    

def main():
    reader_branches()
    reader()
    romInit(32, 256)

if __name__ == '__main__':
    main()
