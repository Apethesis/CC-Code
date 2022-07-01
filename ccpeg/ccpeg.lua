local args = {...}

if args[1] == nil then
    print("Usage:\nccpeg.lua <input file> <output file>")
else
    local filein = fs.open(args[1], "r")
    local fileout = fs.open(args[2], "w")
    local type1 = assert(require("decode."..args[1]:match("[^%.]+$")), "input format not supported")
    local type2 = assert(require("encode."..args[2]:match("[^%.]+$")), "output format not supported")
    local tbl = type1(filein)
    type2(tbl, fileout)
end