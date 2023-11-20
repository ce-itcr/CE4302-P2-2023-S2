import re

# Dictionary with the Functions Mapping
Functions = {
    'ADD': 0,
    'SUB': 1,
    'MUL': 2,
    'OR':  3,
    'MOD': 4,
    'AND': 5,
    'MOV': 6,
    'DIV': 7,
    'CMP': 8
}

def parse_instruction(instruction):
    # Format 1: {operation} R{number} R{number} R{number}
    format1_pattern = re.compile(r'(\w+)\s+R(\d+)\s+R(\d+)\s+R(\d+)')
    
    # Format 2: {operation} R{number} R{number} #{number}
    format2_pattern = re.compile(r'(\w+)\s+R(\d+)\s+R(\d+)\s+#(\d+)')
    
    # Format 3: CMP R{number} R{number}
    format3_pattern = re.compile(r'CMP\s+R(\d+)\s+R(\d+)')
    
    # Format 4: B{condition} {number}
    format4_pattern = re.compile(r'B([A-Z]+)\s+(\d+)')
    
    # Format 5: {operation} R{number} [R{number} #{number}]
    format5_pattern = re.compile(r'(\w+)\s+R(\d+)\s+(?:\[R(\d+)\s+#(\d+)\])?')

    # Check for each format
    match = format1_pattern.match(instruction)
    if match:
      
        Function = match.group(1)
        RD = int(match.group(2))
        RA = int(match.group(3))
        RB = int(match.group(4))
    
        # Create the datapath
        cond = bin(0b0110)[2:]
        op = bin(0b00)[2:]
        imm = bin(0b0)[2:]
        func = bin(Functions[Function])[2:]
        ls = bin(0b0)[2:]
        Ra = bin(RA)[2:]
        Rd = bin(RD)[2:]
        
    

    match = format2_pattern.match(instruction)
    if match:
        return {
            'Function': match.group(1),
            'RD': int(match.group(2)),
            'RA': int(match.group(3)),
            'Immediate': int(match.group(4)),
        }

    match = format3_pattern.match(instruction)
    if match:
        return {
            'Function': 'CMP',
            'RA': int(match.group(1)),
            'RB': int(match.group(2)),
        }

    match = format4_pattern.match(instruction)
    if match:
        return {
            'Conditional': f'B{match.group(1)}',
            'Immediate': int(match.group(2)),
        }

    match = format5_pattern.match(instruction)
    if match:
        return {
            'Function': match.group(1),
            'RD': int(match.group(2)),
            'RBase': int(match.group(3)) if match.group(3) else None,
            'Immediate': int(match.group(4)) if match.group(4) else None,
        }

    # If none of the formats match
    return None

# Receive the instruction as input
while True:
    instruction = input("Type the TessiaX32 instruction: ")
    print(parse_instruction(instruction))
    print()
