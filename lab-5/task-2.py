class MIPS_Simulator:
    def __init__(self):
        self.registers = [0] * 32  # 32 registers
        self.memory = [0] * 1024    # Memory (size simplified)
        self.PC = 0  # Program Counter
        self.control_signals = {}  # To hold control signals for each instruction

    def fetch_instruction(self, binary_instructions):
        """Fetch the instruction from the binary file using PC."""
        if self.PC < len(binary_instructions):
            instruction = binary_instructions[self.PC]
            self.PC += 1
            return instruction
        return None

    def decode_instruction(self, instruction):
        """Decode the binary instruction into its components"""
        opcode = instruction[:6]
        rs = int(instruction[6:11], 2)
        rt = int(instruction[11:16], 2)
        
        if opcode == '000000':  # R-type instruction
            rd = int(instruction[16:21], 2)
            shamt = int(instruction[21:26], 2)
            funct = instruction[26:]
            return {
                'type': 'R',
                'opcode': opcode,
                'rs': rs,
                'rt': rt,
                'rd': rd,
                'shamt': shamt,
                'funct': funct,
                'immediate': None,
                'address': None
            }

        elif opcode in ['000010', '000011']:  # J-type instruction (jump or jal)
            address = int(instruction[6:], 2)
            return {
                'type': 'J',
                'opcode': opcode,
                'rs': None,
                'rt': None,
                'rd': None,
                'shamt': None,
                'funct': None,
                'immediate': None,
                'address': address
            }

        else:  # I-type instruction (lw, sw, beq, etc.)
            immediate = int(instruction[16:], 2)  # Last 16 bits
            return {
                'type': 'I',
                'opcode': opcode,
                'rs': rs,
                'rt': rt,
                'rd': None,
                'shamt': None,
                'funct': None,
                'immediate': immediate,
                'address': None
            }

    def execute(self, opcode, rs, rt, rd, shamt, funct, immediate, address):
        """Execute the ALU or branching operation."""
        if opcode == '000000':  # R-type instructions
            if funct == '100000':  # ADD (add $t0, $t1, $t2)
                # Debug: Before ADD
                print(f"Before ADD: $r{rs} = {self.registers[rs]}, $r{rt} = {self.registers[rt]}")
                
                # Perform ADD
                self.registers[rd] = self.registers[rs] + self.registers[rt]
                
                # Debug: After ADD
                print(f"ADD executed: $r{rd} = $r{rs} + $r{rt} -> {self.registers[rd]}")

        elif opcode == '100011':  # LW (lw $t3, 100($s0))
            address = self.registers[rs] + immediate
            self.registers[rt] = self.memory[address]
            print(f"LW executed: Loaded memory[{address}] into $r{rt} -> {self.registers[rt]}")

        elif opcode == '000100':  # BEQ (beq $t0, $zero, 25)
            if self.registers[rs] == self.registers[rt]:
                self.PC += immediate
                print(f"BEQ executed: Branch taken, PC updated to {self.PC}")
            else:
                print(f"BEQ not taken: $r{rs} != $r{rt}")

        elif opcode == '000010':  # JUMP (j 1000)
            self.PC = address
            print(f"Jump executed: PC set to {self.PC}")

    def memory_access(self, opcode, rt, rs, immediate):
        """Simulate the Memory Access stage for load/store instructions."""
        if opcode == '100011':  # LW
            address = self.registers[rs] + immediate
            self.registers[rt] = self.memory[address]
            print(f"LW Memory Access: Loaded memory[{address}] into $r{rt}")

    def write_back(self, rd, value):
        """Simulate the Write Back stage."""
        self.registers[rd] = value
        print(f"Write Back: $r{rd} = {value}")

    def run(self, binary_instructions):
        """Simulate the MIPS execution pipeline."""
        while self.PC < len(binary_instructions):
            instruction = self.fetch_instruction(binary_instructions)
            if instruction is None:
                break

            # Instruction Fetch (IF)
            print(f"Fetched Instruction: {instruction}")

            # Instruction Decode (ID)
            decoded_instr = self.decode_instruction(instruction)
            print(f"Decoded: {decoded_instr}")

            # Execution (EX) based on instruction type
            if decoded_instr['type'] == 'R':
                # R-type (add, sub, etc.)
                opcode = decoded_instr['opcode']
                rs = decoded_instr['rs']
                rt = decoded_instr['rt']
                rd = decoded_instr['rd']
                shamt = decoded_instr['shamt']
                funct = decoded_instr['funct']
                immediate = None
                address = None
            elif decoded_instr['type'] == 'I':
                # I-type (lw, sw, beq, etc.)
                opcode = decoded_instr['opcode']
                rs = decoded_instr['rs']
                rt = decoded_instr['rt']
                rd = None
                shamt = None
                funct = None
                immediate = decoded_instr['immediate']
                address = None
            elif decoded_instr['type'] == 'J':
                # J-type (jump, jal)
                opcode = decoded_instr['opcode']
                rs = None
                rt = None
                rd = None
                shamt = None
                funct = None
                immediate = None
                address = decoded_instr['address']
            
            # Call the execute function
            self.execute(opcode, rs, rt, rd, shamt, funct, immediate, address)

            # Memory Access (MEM) for I-type (load/store instructions)
            if decoded_instr['type'] == 'I':
                self.memory_access(opcode, rt, rs, immediate)

            # Write Back (WB) for R-type and I-type instructions
            if decoded_instr['type'] == 'R':
                self.write_back(rd, self.registers[rd])
            elif decoded_instr['type'] == 'I':
                self.write_back(rt, self.registers[rt])

        self.display_registers()

    def display_registers(self):
        """Display the register values after execution."""
        print("Final Register Values:")
        for i in range(32):
            print(f"$r{i}: {self.registers[i]}")

def load_binary_instructions(file_path):
    with open(file_path, 'r') as f:
        binary_instructions = f.read().splitlines()
    return binary_instructions

if __name__ == "__main__":
    file_path = "output.bin"  # Binary file containing MIPS instructions
    binary_instructions = load_binary_instructions(file_path)

    # Create a MIPS simulator instance
    simulator = MIPS_Simulator()
    
    # Initialize registers for testing
    simulator.registers[8] = 5  # Example initial value for $r8
    simulator.registers[9] = 10  # Example initial value for $r9
    
    simulator.run(binary_instructions)
