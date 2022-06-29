local path = "/"..string.sub(shell.dir(), 1, 14)
local oldpath = package.path
package.path = string.format("%s;/%s/?.lua;/%s/?/init.lua", package.path, path, path)
local base = require("main")
package.path = oldpath

return function(filein,fileout)
    -- both filein and fileout will be file handles
    -- make sure to close them when you're done
    -- anyway conversion code here
end