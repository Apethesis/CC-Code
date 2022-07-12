local bbf = require("lib.bbf")

return function(tbl, fileout, filepath)
    -- fileout will be a file handle, make sure to close it when your done
    -- tbl will just be a regular table with the data to be encoded
    -- the function should take the table and write the correct format to the file
    -- intermediate format is map[layer][y][x] = { background, foreground, text }
    -- background and foreground are both blit values
    fileout.close()
    fileout = bbf.open(filepath, "w")
end