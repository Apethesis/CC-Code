local base = require("main")

return function(filein)
    -- filein will be a file handle, make sure to close it when your done
    -- the function should return a table with the data
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
end