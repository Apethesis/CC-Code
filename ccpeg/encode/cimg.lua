local path = fs.getDir(select(2,...) or "")
local oldpath = package.path
package.path = string.format("%s;/%s/?.lua;/%s/?/init.lua", package.path, path, path)
local base = require("main")
package.path = oldpath

return function(tbl, fileout)
    local tbl1 = {}
    for y,_temp in pairs(tbl[1]) do
        for x,data in pairs(_temp) do
            tbl1[x] = tbl1[x] or {}
            tbl1[x][y] = data.background
        end
    end
    fileout.write(textutils.serialize(tbl1))
    fileout.close()
    return true
end