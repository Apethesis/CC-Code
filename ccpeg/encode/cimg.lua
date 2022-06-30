local path = fs.getDir(select(2,...) or "")
local oldpath = package.path
package.path = string.format("%s;/%s/?.lua;/%s/?/init.lua", package.path, path, path)
local base = require("main")
package.path = oldpath

return function(tbl, fileout)
    -- fileout will be a file handle, make sure to close it when your done
    -- tbl will just be a regular table with the data to be encoded
    -- the function should take the table and write the correct format to the file
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
    local tbl1 = {}
    for y,_temp in pairs(tbl[1]) do
        for x,data in pairs(_temp) do
            tbl1[x] = tbl1[x] or {}
            tbl1[x][y] = data.background
        end
    end
    fileout.write(textutils.serialize(tbl1))
    fileout.close()
end