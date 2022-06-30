local args = {...}

if args[1] == nil then
    print("Usage:\nccpeg.lua <input file> <output file>")
else
    local filein = fs.open(args[1], "r")
    local fileout = fs.open(args[2], "w")
    local type1 = require("decode."..args[1]:match("[^%.]+$"))
    local type2 = require("encode."..args[2]:match("[^%.]+$"))
    if type1 == nil then
        error("Unable to decode format, reason: Format Not Supported",0)
    elseif type2 == nil then
        error("Unable to encode format, reason: Format Not Supported",0)
    end
    local tbl = type1(filein)
    type2(tbl, fileout)
end