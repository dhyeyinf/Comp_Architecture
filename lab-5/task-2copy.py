class MIPSProcessor:
    def __init__(self):
        self.pc = 0  # Program Counter
        self.registers = {f'${i}': 0 for i in range(32)}  # 32 registers
        self.memory = [0] * 1024  # 1024 words of memory
        self.instructions = []

    def load_instructions(self, filename):
        with open(filename, 'r') as file:
            self.instructions = [line.strip() for line in file if line.strip()]
        print(f"Loaded {len(self.instructions)} instructions")

    def fetch(self):
        if self.pc < len(self.instructions):
            instruction = self.instructions[self.pc]
            self.pc += 1
            return instruction
        return None

    def decode(self, instruction):
        opcode = instruction[:6]
        if opcode == '000000':  # R-type
            rs = int(instruction[6:11], 2)
            rt = int(instruction[11:16], 2)
            rd = int(instruction[16:21], 2)
            shamt = int(instruction[21:26], 2)
            funct = instruction[26:]
            return ('R', funct, rs, rt, rd, shamt)
        elif opcode in ['100011', '101011', '000100']:  # lw, sw, beq
            rs = int(instruction[6:11], 2)
            rt = int(instruction[11:16], 2)
            imm = int(instruction[16:], 2)
            if imm & 0x8000:  # Sign extend
                imm -= 0x10000
            return ('I', opcode, rs, rt, imm)
        elif opcode == '000010':  # j
            addr = int(instruction[6:], 2)
            return ('J', opcode, addr)
        else:
            raise ValueError(f"Unknown instruction: {instruction}")

    def execute(self, decoded_instr):
        instr_type = decoded_instr[0]
        if instr_type == 'R':
            _, funct, rs, rt, rd, _ = decoded_instr
            if funct == '100000':  # add
                self.registers[f'${rd}'] = self.registers[f'${rs}'] + self.registers[f'${rt}']
            elif funct == '100010':  # sub
                self.registers[f'${rd}'] = self.registers[f'${rs}'] - self.registers[f'${rt}']
            # Add more R-type instructions as needed
        elif instr_type == 'I':
            _, opcode, rs, rt, imm = decoded_instr
            if opcode == '100011':  # lw
                address = self.registers[f'${rs}'] + imm
                self.registers[f'${rt}'] = self.memory[address]
            elif opcode == '101011':  # sw
                address = self.registers[f'${rs}'] + imm
                self.memory[address] = self.registers[f'${rt}']
            elif opcode == '000100':  # beq
                if self.registers[f'${rs}'] == self.registers[f'${rt}']:
                    self.pc += imm
        elif instr_type == 'J':
            _, _, addr = decoded_instr
            self.pc = addr

    def run(self):
        while True:
            instruction = self.fetch()
            if instruction is None:
                break
            decoded = self.decode(instruction)
            self.execute(decoded)
            print(f"Executed: {instruction}")
            print(f"Registers: {self.registers}")
            print(f"PC: {self.pc}")
            print("--------------------")

def main():
    processor = MIPSProcessor()
    processor.load_instructions('output.bin')  # Load instructions from Task 1 output
    processor.run()
    print("Simulation complete.")
    print(f"Final register state: {processor.registers}")

if __name__ == "__main__":
    main()