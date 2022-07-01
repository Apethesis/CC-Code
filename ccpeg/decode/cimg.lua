local base = require("main")
return function(filein)
    local tbl1 = textutils.unserialize(filein.readAll())
    local tbl2 = {}
    for x,_temp in pairs(tbl1) do
        for y,data in pairs(_temp) do
            tbl2[1] = tbl2[1] or {}
            tbl2[1][y] = tbl2[1][y] or {}
            tbl2[1][y][x] = { background = data, foreground = "0", text = " " }
        end
    end
    tbl1.close()
    return true, tbl2
end