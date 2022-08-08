-- My 8 bit (i think) CPU made to work with CC, but easily modifiable to work with regular lua most likely.
-- Recommended to use 'lasm' instead of manually writing opcodes
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
        ["INS_SUB"] = 0x0D,
        ["INS_OUT"] = 0x0E,
        ["INS_TOUT"] = 0x0F,
        ["INS_JMP"] = 0x10,
        ["INS_TRM_SCP"] = 0x11,
        ["INS_TRM_SBC"] = 0x12,
        ["INS_TRM_SFC"] = 0x13,
        ["INS_TRM_WRT"] = 0x14,
        ["INS_TRM_CLR"] = 0x15,
        ["INS_PAUSE"] = 0x16
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
        end,
        [0x0E] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            print(dt1)
        end,
        [0x0F] = function(mem)
            local dt1 = CPU.fetchbyte(mem) 
            print(keys.getName(dt1))
        end,
        [0x10] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            CPU.PC = dt1
        end,
        [0x11] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            local dt2 = CPU.fetchbyte(mem)
            term.setCursorPos(dt1,dt2)
        end,
        [0x12] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            term.setBackgroundColor(dt1)
        end,
        [0x13] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            term.setTextColor(dt1)
        end,
        [0x14] = function(mem)
            local dt1 = CPU.fetchbyte(mem)
            term.write(dt1)
        end,
        [0x15] = function()
            term.clear()
        end,
        [0x16] = function(mem)
            local tm = CPU.fetchbyte(mem)
            sleep(tm)
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
