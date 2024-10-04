import re # re documentation # https://docs.python.org/3/library/re.html

R_TYPE = 0
I_TYPE = 1
J_TYPE = 2

opcodes = {
    'add': '000000', 'sub': '000000', 'and': '000000', 'or': '000000', 'slt': '000000',
    'lw': '100011', 'sw': '101011', 'beq': '000100', 'addi': '001000',
    'j': '000010'
}

function_codes = {
    'add': '100000', 'sub': '100010', 'and': '100100', 'or': '100101', 'slt': '101010'
}

registers = {
    '$zero': '00000', '$at': '00001', '$v0': '00010', '$v1': '00011',
    '$a0': '00100', '$a1': '00101', '$a2': '00110', '$a3': '00111',
    '$t0': '01000', '$t1': '01001', '$t2': '01010', '$t3': '01011',
    '$t4': '01100', '$t5': '01101', '$t6': '01110', '$t7': '01111',
    '$s0': '10000', '$s1': '10001', '$s2': '10010', '$s3': '10011',
    '$s4': '10100', '$s5': '10101', '$s6': '10110', '$s7': '10111',
    '$t8': '11000', '$t9': '11001', '$k0': '11010', '$k1': '11011',
    '$gp': '11100', '$sp': '11101', '$fp': '11110', '$ra': '11111'
}

def read_input_file(filename):
    try:
        with open(filename, 'r') as file:
            lines = [line.strip() for line in file if line.strip() and not line.strip().startswith('#')]
        print(f"Read {len(lines)} lines from {filename}")
        return lines
    except FileNotFoundError:
        print(f"Error: File '{filename}' not found.")
        return None
    except Exception as e:
        print(f"Error reading file: {e}")
        return None

def parse_instruction(instruction):
    print(f"Parsing instruction: {instruction}")
    parts = re.split(r'[,\s]+', instruction.strip())
    op = parts[0]

    if op in ['add', 'sub', 'and', 'or', 'slt']:
        if len(parts) != 4:
            raise ValueError(f"Invalid R-type instruction format: {instruction}")
        return (R_TYPE, op, parts[1], parts[2], parts[3])
    elif op in ['lw', 'sw', 'beq', 'addi']:
        if op in ['lw', 'sw']:
            # Handle lw and sw instructions
            match = re.match(r'(\w+)\s+(\$\w+)\s*,\s*(-?\d+)\s*\(\s*(\$\w+)\s*\)', instruction)
            if match:
                op, rt, offset, rs = match.groups()
                print(f"Parsed memory access: op={op}, rt={rt}, offset={offset}, rs={rs}")
                return (I_TYPE, op, rs, rt, offset)
            else:
                raise ValueError(f"Invalid format for memory access instruction: {instruction}")
        elif op == 'beq':
            if len(parts) != 4:
                raise ValueError(f"Invalid beq instruction format: {instruction}")
            return (I_TYPE, op, parts[1], parts[2], parts[3])
        else:  # addi
            if len(parts) != 4:
                raise ValueError(f"Invalid addi instruction format: {instruction}")
            return (I_TYPE, op, parts[2], parts[1], parts[3])
    elif op == 'j':
        if len(parts) != 2:
            raise ValueError(f"Invalid J-type instruction format: {instruction}")
        return (J_TYPE, op, parts[1])
    else:
        raise ValueError(f"Unknown instruction: {instruction}")

    
def compile_r_type(op, rs, rt, rd):
    opcode = opcodes[op]
    rs = registers[rs]
    rt = registers[rt]
    rd = registers[rd]
    shamt = '00000'
    funct = function_codes[op]
    return f"{opcode}{rs}{rt}{rd}{shamt}{funct}"

def compile_i_type(op, rs, rt, imm):
    opcode = opcodes[op]
    rs = registers[rs]
    rt = registers[rt]
    imm = format(int(imm) & 0xFFFF, '016b')  # Convert to 16-bit binary
    return f"{opcode}{rs}{rt}{imm}"

def compile_j_type(op, addr):
    opcode = opcodes[op]
    addr = format(int(addr) & 0x3FFFFFF, '026b')  #26bit convert krna hai
    return f"{opcode}{addr}"

def compile_instruction(parsed_instruction):
    instr_type, op, *args = parsed_instruction
    if instr_type == R_TYPE:
        return compile_r_type(op, *args)
    elif instr_type == I_TYPE:
        return compile_i_type(op, *args)
    elif instr_type == J_TYPE:
        return compile_j_type(op, *args)

def compile_program(assembly_code):
    binary_code = []
    for instruction in assembly_code:
        try:
            parsed = parse_instruction(instruction)
            binary = compile_instruction(parsed)
            binary_code.append(binary)
            print(f"Compiled: {instruction} -> {binary}")
        except Exception as e:
            print(f"Error compiling instruction '{instruction}': {e}")
    return binary_code

def write_output_file(binary_code, filename):
    try:
        with open(filename, 'w') as file:
            for instruction in binary_code:
                file.write(f"{instruction}\n")
        print(f"Successfully wrote {len(binary_code)} instructions to {filename}")
    except Exception as e:
        print(f"Error writing to file: {e}")

def main():
    input_file = "input.asm" 
    output_file = "output.bin"
    
    assembly_code = read_input_file(input_file)
    if assembly_code is None:
        print("Error: Failed to read assembly code.")
        return
    
    print(f"Number of instructions read: {len(assembly_code)}")
    binary_code = compile_program(assembly_code)
    
    if binary_code:
        write_output_file(binary_code, output_file)
        print(f"Compilation complete. Output written to {output_file}")
    else:
        print("Compilation failed.")

if __name__ == "__main__":
    main()  