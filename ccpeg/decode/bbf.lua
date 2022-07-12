local base = require("main")
local bbf = require("lib.bbf")

return function(filein, filepath)
    -- filein will be a file handle, make sure to close it when your done
    -- the function should return a table with the data
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
    filein.close()
    filein = bbf.open(filepath, "r")
    local map = {}
    local index_map = {"text","foreground","background"}
    for layer=1,filein.layers do
        for y=1,filein.height do
            for index,line in ipairs({filein:read_line(layer, y)}) do
                local x = 0
                for c in line:gmatch(".") do
                    x = x + 1
                    map[layer] = map[layer] or {}
                    map[layer][y] = map[layer][y] or {}
                    map[layer][y][x] = map[layer][y][x] or {}
                    map[layer][y][x][index_map[index]] = c
                end
            end
        end
    end
    return map
end