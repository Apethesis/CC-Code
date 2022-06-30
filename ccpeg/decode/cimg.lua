local path = "/"..string.sub(shell.dir(), 1, 14)
local oldpath = package.path
package.path = string.format("%s;/%s/?.lua;/%s/?/init.lua", package.path, path, path)
local base = require("main")
package.path = oldpath

return function(filein)
    local tbl1 = textutils.serialize(filein.readAll())
    local tbl2 = {}
    for x,_temp in pairs(tbl1) do
        for y,data in pairs(_temp) do
            tbl2[1] = tbl2[1] or {}
            tbl2[1][y] = tbl2[1][y] or {}
            tbl2[1][y][x] = { background = data, foreground = "0", text = " " }
        end
    end
    tbl1.close()
    return tbl2
end