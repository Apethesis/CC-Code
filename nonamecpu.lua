-- My 8 bit (i think) CPU made to work with CC, but easily modifiable to work with regular lua most likely.
-- Recommended to use 'lasm' instead of manually writing opcodes
local MEM = setmetatable({ SP = 0 }, { __index = 0 })
local CPU = {
    PC = 0x01,
    IR = {
        A = 0,
        B = 0
    },
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
        ["INS_TRM_STC"] = 0x13,
        ["INS_TRM_WRT"] = 0x14,
        ["INS_TRM_CLR"] = 0x15,
        ["INS_PAUSE"] = 0x16,
        ["INST_OUTIR"] = 0x17
    },
    ["TRM_COLR"] = {
        [0x00] = colors.white,
        [0x01] = colors.orange,
        [0x02] = colors.magenta,
        [0x03] = colors.lightBlue,
        [0x04] = colors.yellow,
        [0x05] = colors.lime,
        [0x06] = colors.pink,
        [0x07] = colors.gray,
        [0x08] = colors.lightGray,
        [0x09] = colors.cyan,
        [0x0A] = colors.purple,
        [0x0B] = colors.blue,
        [0x0C] = colors.brown,
        [0x0D] = colors.green,
        [0x0E] = colors.red,
        [0x0F] = colors.black
    }
}
for i=1,256 do
    MEM[i] = 0
end
local args = {...}
args[1] = args[1] or "/save"
local logfile = fs.open("/.log","w")
local log = ""
local PC = 0x01
function CPU.fetchbyte(mem)
    local dat = mem[CPU.PC]
    CPU.PC = (CPU.PC + 1) % 256
    return dat
end
function CPU.readbyte(mem)
    local dat = mem[CPU.PC]
    PC = PC + 1
    return dat
end
local function exec(meem)
    local warisacruelparentbutaneffectiveteacheritsfinallessoniscarveddeepinmypsychethatthisworldandallitspeoplearediseasedfreewillisamythreligionisajokeweareallpawnscontrolledbysomethinggreatermemesthednaofthesoultheyshapeourwilltheyaretheculturetheyareeverythingwepassonexposesomeonetoangerlongenoughtheywilllearntohatetheybecomeacarrierenvygreeddespairallmemesallpassedalong = false
    local ftbl = {
        [0x01] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            CPU.IR.A = bit32.band(dt1, dt2)
        end,
        [0x02] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            CPU.IR.A = bit32.bor(dt1, dt2)
        end,
        [0x03] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            CPU.IR.A = bit32.band(bit32.bnot(dt1), bit32.bnot(dt2))
        end,
        [0x04] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            CPU.IR.A = bit32.bor(bit32.bnot(dt1), bit32.bnot(dt2))
        end,
        [0x05] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            CPU.IR.A = bit32.bxor(dt1, dt2)
        end,
        [0x06] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            CPU.IR.A = bit32.bnot(dt1)
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
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            mem[dt2] = dt1
        end,
        [0x0A] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            if dt1 == 0x01 then
                CPU.IR.A = dt2
            elseif dt1 == 0x02 then
                CPU.IR.B = dt2
            end
        end,
        [0x0B] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            if dt1 == 0x01 then
                mem[dt2] = CPU.IR.A
            elseif dt1 == 0x02 then
                mem[dt2] = CPU.IR.B
            end
        end,
        [0x0C] = function(mem)
            local a = CPU.fetchbyte(mem) or 0
            local b = CPU.fetchbyte(mem) or 0
            CPU.IR.B = (a + b) % 256
        end,
        [0x0D] = function(mem)
            local a = CPU.fetchbyte(mem) or 0
            local b = CPU.fetchbyte(mem) or 0
            CPU.IR.B = a - b; if CPU.IR.B < 0 then CPU.IR.B = CPU.IR.B + 256 end
        end,
        [0x0E] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            print(dt1)
        end,
        [0x0F] = function(mem)
            local dt1 = CPU.fetchbyte(mem)  or 0
            print(keys.getName(dt1))
        end,
        [0x10] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            CPU.PC = dt1
        end,
        [0x11] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            local dt2 = CPU.fetchbyte(mem) or 0
            term.setCursorPos(dt1,dt2)
        end,
        [0x12] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            term.setBackgroundColor(CPU.TRM_COLR[dt1])
        end,
        [0x13] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            term.setTextColor(CPU.TRM_COLR[dt1])
        end,
        [0x14] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0
            term.write(dt1)
        end,
        [0x15] = function()
            term.clear()
        end,
        [0x16] = function(mem)
            local tm = CPU.fetchbyte(mem) or 0
            sleep(tm)
        end,
        [0x17] = function(mem)
            local dt1 = CPU.fetchbyte(mem) or 0x01
            if dt1 == 0x01 then
                print(tostring(CPU.IR.A))
            elseif dt1 == 0x02 then
                print(tostring(CPU.IR.B))
            end
        end
    }
    repeat
        local ins = CPU.fetchbyte(MEM)
        if ftbl[ins] then
            ftbl[ins](MEM)
            log = log.."Executed instruction "..ins.."\n"
        elseif ftbl[ins] ~= nil then
            log = log.."Invalid instruction at "..CPU.PC-1 .."\n"
        end
        if CPU.PC == 255 then
            warisacruelparentbutaneffectiveteacheritsfinallessoniscarveddeepinmypsychethatthisworldandallitspeoplearediseasedfreewillisamythreligionisajokeweareallpawnscontrolledbysomethinggreatermemesthednaofthesoultheyshapeourwilltheyaretheculturetheyareeverythingwepassonexposesomeonetoangerlongenoughtheywilllearntohatetheybecomeacarrierenvygreeddespairallmemesallpassedalong = true
        end
    until warisacruelparentbutaneffectiveteacheritsfinallessoniscarveddeepinmypsychethatthisworldandallitspeoplearediseasedfreewillisamythreligionisajokeweareallpawnscontrolledbysomethinggreatermemesthednaofthesoultheyshapeourwilltheyaretheculturetheyareeverythingwepassonexposesomeonetoangerlongenoughtheywilllearntohatetheybecomeacarrierenvygreeddespairallmemesallpassedalong
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

logfile.write(log) 
logfile.close()
