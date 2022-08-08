-- Lua Assembler
-- Converts Assembly looking code into a table compatible with my CPU
local args = {...}
local mybraindamageisrisingitsoverflowing = false
local inst = {
    AND = 0x01,
    OR = 0x02,
    NAND = 0x03,
    NOR = 0x04,
    XOR = 0x05,
    NOT = 0x06,
    BREAK = 0x07,
    SAVE = 0x08,
    MOVE = 0x09,
    MOVEMR = 0x0A,
    MOVERM = 0x0B,
    ADD = 0x0C,
    SUB = 0x0D,
    OUT = 0x0E,
    TEXOUT = 0x0F,
    JUMP = 0x10,
    ["TRM_SCP"] = 0x11,
    ["TRM_SBC"] = 0x12,
    ["TRM_SFC"] = 0x13,
    ["TRM_WRT"] = 0x14,
    ["TRM_CLR"] = 0x15,
    SLEEP = 0x16,
    VAR = 0x17
}
local fl1 = fs.open(args[1],"r")
local fl2 = fs.open(args[2],"w")
local vtbl = {}
local otbl = { ["CPC"] = 0x01 }
local cur = 0x01
repeat
    local ln = fl1.readLine()
    if ln then
        local chunks = {}
        for substring in ln:gmatch("%S+") do
            table.insert(chunks, substring)
        end
        for k,v in pairs(chunks) do
            if chunks[1] == "VAR" then
                if k == 1 then
                    vtbl[chunks[2]] = tonumber(chunks[3])
                    cur = cur + 1
                end
                otbl[cur] = tonumber(v)
                cur = cur + 1
            else
                if k == 1 then
                    otbl[cur] = inst[v]
                    cur = cur + 1
                else
                    otbl[cur] = tonumber(v)
                    cur = cur + 1
                end
            end
        end
    else
        mybraindamageisrisingitsoverflowing = true
    end
until mybraindamageisrisingitsoverflowing
for k1,v1 in pairs(vtbl) do
    for k2,v2 in pairs(otbl) do
        if v2 == k1 then
            otbl[v2] = v1
        end
    end
end
fl2.write(textutils.serialize(otbl))
fl1.close()
fl2.close()
