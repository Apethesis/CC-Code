local CPU = {
    ["PC"] = 0,
    ["SP"] = 0,
    ["IR"] = {
        ["A"] = 0,
        ["X"] = 0,
        ["Y"] = 0
    },
    ["SF"] = {
        ["C"] = 0,
        ["Z"] = 0,
        ["I"] = 0,
        ["D"] = 0,
        ["B"] = 0,
        ["V"] = 0,
        ["N"] = 0
    },
    ["INSTR"] = {
        ["INS_LDA_IM"] = 0xA9,
        ["INS_LDA_ZP"] = 0xA5,
        ["INS_LDA_ZPX"] = 0xB5,
        ["INS_JSR"] = 0x20,
        ["INS_JMPA"] = 0x4C,
        ["INS_JMPI"] = 0x6C,
        ["INS_RTS"] = 0x60
    }
}

local MEM = {
    ["MAX_MEM"] = 1024 * 64,
    ["DATA"] = {}
}

function MEM.init()
    MEM.DATA = {}
end

function CPU.reset(mem)
    CPU.PC = 0xFFFC
    CPU.SP = 0x0100
    for k,v in pairs(CPU.SF) do
        CPU.SF[k] = 0
    end
    CPU.IR["A"] = 0 CPU.IR["X"] = 0 CPU.IR["Y"] = 0
    mem.init()
end

function MEM:operator(addr)
    return self.DATA[addr]
end

function CPU.fetchbyte(cycle,mem)
    local dta = mem.DATA[CPU.PC]
    CPU.PC = CPU.PC + 1
    cycle = cycle - 1
    return dta
end

function CPU.fetchword(cycle,mem)
    local dta1 = mem.DATA[CPU.PC]
    CPU.PC = CPU.PC + 1
    dta1 = bit32.bor(dta1, bit32.lshift(mem.DATA[CPU.PC], 8))
    CPU.PC = CPU.PC + 1
    cycle = cycle + 2
    return dta1
end

function CPU.readbyte(cycle, addr, mem)
    local dta = mem.DATA[addr]
    cycle = cycle - 1
    return dta
end

function MEM:writeword(dat, addr, cycl)
    self.DATA[addr] = bit32.band(dat, 0xFF)
    self.DATA[addr+1] = bit32.arshift(dat,8) 
    cycl = cycl - 2
end

function CPU.LDASetStatus()
    if CPU.IR.A == 0 then
        CPU.SF.Z = 1
    end
    if bit32.band(CPU.IR.A, 128) then
        CPU.SF.N = 1
    end
end

function CPU.exec(cycle, mem)
    while cycle > 0 do
        local ins = CPU.fetchbyte(cycle,mem)
        if ins == CPU.INSTR.INS_LDA_IM then
            local val = CPU.fetchbyte(cycle,mem)
            CPU.IR.A = val
            CPU.LDASetStatus()
        elseif ins == CPU.INSTR.INS_LDA_ZP then
            local zpa = CPU.fetchbyte(cycle,mem) 
            CPU.IR.A = CPU.readbyte(cycle, zpa, mem) 
            CPU.LDASetStatus()
        elseif ins == CPU.INSTR.INS_LDA_ZPX then
            local zpa = CPU.fetchbyte(cycle,mem) 
            zpa = zpa + CPU.IR.X
            cycle = cycle - 1
            CPU.IR.A = CPU.readbyte(cycle, zpa, mem)
            CPU.LDASetStatus()
        elseif ins == CPU.INSTR.INS_JSR then
            local SubADDR = CPU.fetchword(cycle,mem)
            MEM:writeword( CPU.PC-1, CPU.SP, cycle)
            CPU.PC = SubADDR
            cycle = cycle - 1
            CPU.SP = CPU.SP + 1
        elseif ins == CPU.INSTR.RTS then
            -- todo, make this and the other undefined instructions
        else
            print("Instruction not handled "..ins)
        end
    end
end

CPU.reset(MEM)
MEM.DATA[0xFFFC] = CPU.INSTR.INS_LDA_ZP
MEM.DATA[0xFFFD] = 0x42
MEM.DATA[0x0042] = 0x84
CPU.exec(3,MEM)
