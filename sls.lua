-- It stands for "Shitty LiSt"

-- Getting peclib if it doesnt exist
if not fs.exists("./peclib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/peclib.lua")
    local htf = fs.open("./peclib.lua","w")
    htf.write(htg.readAll())
    htf.close()
    htg.close()
end
local peclib = require("peclib")

-- Making the file table
local fll = fs.list("/"..shell.dir())
local ftbl = {}
local fldrnum = 1
for k,v in pairs(fll) do
    if fs.isDir(v) then
        ftbl[fldrnum] = v
        fldrnum = fldrnum + 1
    end
    if not fs.isDir(v) then
        table.insert(ftbl, v)
    end
end

-- Printing it out
local cx,cy = term.getCursorPos()
local ax = 1
local ay = cy
for k,v in pairs(ftbl) do
    local ext = v:match("[^%.]+$")
    local filesize = fs.getSize(v)
    local kbsize = string.sub(tostring(filesize / 1024), 1, 4)
    if fs.isReadOnly(v) and fs.isDir(v) then
        if v == "rom" then
            peclib.prite(ax,ay,"rom",colors.red,colors.black)
            ay = ay + 1
        end
        if v ~= "rom" then
            peclib.prite(ax,ay,v,colors.red,colors.black)
            ay = ay + 1
        end
    end
    if fs.isReadOnly(v) then
        if v ~= "rom" then
            peclib.prite(ax,ay,v.."    "..kbsize.."KB",colors.orange,colors.black)
            ay = ay + 1
        end
    end
    if fs.isDir(v) then
        if v ~= "rom" then
            peclib.prite(ax,ay,v,colors.yellow,colors.black)
            ay = ay + 1
        end
    end
    if ext == "lua" then
        peclib.prite(ax,ay,v.."    "..kbsize.."KB",colors.blue,colors.black)
        ay = ay + 1
    end
    if ext ~= "lua" and fs.isDir(v) ~= true and fs.isReadOnly ~= true then
        peclib.prite(ax,ay,v.."    "..kbsize.."KB",colors.white,colors.black)
        ay = ay + 1
    end
end
print("")
