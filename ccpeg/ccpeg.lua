local args = {...}

if args[1] == nil then
    print("Usage:\nccpeg.lua <input file> <output file>")
else
    local filein = fs.open(args[1], "r")
    local fileout = fs.open(args[2], "w")
    local ok1, type1 = assert(require("decode."..args[1]:match("[^%.]+$")), "input format not supported")
    local ok2, type2 = assert(require("encode."..args[2]:match("[^%.]+$")), "output format not supported")
---@diagnostic disable-next-line: need-check-nil
    local tbl = type1(filein, args[1])
---@diagnostic disable-next-line: need-check-nil
    type2(tbl, fileout, args[2])
end