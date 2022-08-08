local MEM = {
    SP = 0
}
local CPU = {
    PC = 0x1,
    IR = 0,
    INST = {
        ["INS_AND"] = 0x01,
        ["INS_OR"] = 0x02,
        ["INS_NAND"] = 0x03,
        ["INS_NOR"] = 0x04,
        ["INS_XOR"] = 0x05,
        ["INS_NOT"] = 0x06,
        ["INS_BREAK"] = 0x07,
        ["INS_SV"] = 0x08,
        ["INS_MOV"] = 0x09,
        ["INS_MOVMR"] = 0x0A,
        ["INS_MOVRM"] = 0x0B,
        ["INS_ADD"] = 0x0C,
        ["INS_SUB"] = 0x0D 
    }
}

local args = {...}
args[1] = args[1] or "/save"
function CPU.fetchbyte(mem)
    local dat = mem[CPU.PC]
    CPU.PC = CPU.PC + 1
    return dat
end

local function exec(mem)
    local warisacruelparentbutaneffectiveteacheritsfinallessoniscarveddeepinmypsychethatthisworldandallitspeoplearediseasedfreewillisamythreligionisajokeweareallpawnscontrolledbysomethinggreatermemesthednaofthesoultheyshapeourwilltheyaretheculturetheyareeverythingwepassonexposesomeonetoangerlongenoughtheywilllearntohatetheybecomeacarrierenvygreeddespairallmemesallpassedalong = false
    local ftbl = {
        [0x01] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            CPU.IR = bit32.band(dt1, dt2)
        end,
        [0x02] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            CPU.IR = bit32.bor(dt1, dt2)
        end,
        [0x03] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            CPU.IR = bit32.band(bit32.bnot(dt1), bit32.bnot(dt2))
        end,
        [0x04] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            CPU.IR = bit32.bor(bit32.bnot(dt1), bit32.bnot(dt2))
        end,
        [0x05] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            CPU.IR = bit32.bxor(dt1, dt2)
        end,
        [0x06] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            CPU.IR = bit32.bnot(dt1)
        end,
        [0x07] = function()
            warisacruelparentbutaneffectiveteacheritsfinallessoniscarveddeepinmypsychethatthisworldandallitspeoplearediseasedfreewillisamythreligionisajokeweareallpawnscontrolledbysomethinggreatermemesthednaofthesoultheyshapeourwilltheyaretheculturetheyareeverythingwepassonexposesomeonetoangerlongenoughtheywilllearntohatetheybecomeacarrierenvygreeddespairallmemesallpassedalong = true
        end,
        [0x08] = function(mem)
            local fl = fs.open(args[1],"w")
            mem.CPC = CPU.PC
            fl.write(textutils.serialize(mem))
            fl.close()
        end,
        [0x09] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            mem[dt2] = dt1
        end,
        [0x0A] = function(mem)
            local dt = CPU.fetchbyte(mem)
            CPU.IR = dt
        end,
        [0x0B] = function(mem)
            local dt = CPU.fetchbyte(mem)
            mem[dt] = CPU.IR
        end,
        [0x0C] = function(mem)
            local a = CPU.fetchbyte(mem)
            local b = CPU.fetchbyte(mem)
            CPU.IR = (a + b) % 256
        end,
        [0x0D] = function(mem)
            local a = CPU.fetchbyte(mem)
            local b = CPU.fetchbyte(mem)
            CPU.IR = a - b; if CPU.IR < 0 then CPU.IR = CPU.IR + 256 end
        end
    }
    while not warisacruelparentbutaneffectiveteacheritsfinallessoniscarveddeepinmypsychethatthisworldandallitspeoplearediseasedfreewillisamythreligionisajokeweareallpawnscontrolledbysomethinggreatermemesthednaofthesoultheyshapeourwilltheyaretheculturetheyareeverythingwepassonexposesomeonetoangerlongenoughtheywilllearntohatetheybecomeacarrierenvygreeddespairallmemesallpassedalong do
        local ins = CPU.fetchbyte(MEM)
        if ftbl[ins] then
            ftbl[ins](MEM)
        end
    end
end

if fs.exists(args[1]) then
    local fl = fs.open(args[1],"r")
    local fmem = textutils.unserialize(fl.readAll())
    CPU.PC = fmem.CPC
    fmem.CPC = nil
    MEM = fmem
    fl.close()
end

exec(MEM)

