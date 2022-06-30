local path = "/"..string.sub(shell.dir(), 1, 14)
local oldpath = package.path
package.path = string.format("%s;/%s/?.lua;/%s/?/init.lua", package.path, path, path)
local base = require("main")
package.path = oldpath

return function(filein)
    -- filein will be a file handle, make sure to close it when your done
    -- the function should return a table with the data
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
end