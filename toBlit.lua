local blitTable = {}
local chars = "0123456789abcdef"
for i=0,15 do
    blitTable[2^i] = chars:sub(i+1,i+1)
end

return function toBlit(color)
    return blitTable[color]
end


