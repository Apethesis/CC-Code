local base = require("main")
local bbf = require("lib.bbf")

return function(filein, filepath)
    -- filein will be a file handle, make sure to close it when your done
    -- the function should return a table with the data
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
    filein.close()
    filein = bbf.open(filepath, "r")
    for layer=1,filein.layers do
        for 
    end
end