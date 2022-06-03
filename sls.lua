-- It stands for "Shitty LiSt"

-- Peclib :face_vomiting: 
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

-- Aligned size text - Virtio
local sizex = 0
local strlen = 0
for i, v in ipairs(ftbl) do
    if strlen < #v then
        strlen = #v
        sizex = #v + 2
    end
end

-- Printing it out
local cx,cy = term.getCursorPos()
local writeSize, h = term.getSize()
local ax = 1
local ay = cy
for k,v in pairs(ftbl) do
    local ext = v:match("[^%.]+$")
    local filesize = fs.getSize(v)
    local kbsize = string.sub(tostring(filesize / 1024), 1, 4)
    local writeSize = true
    local color = colors.white
    if fs.isReadOnly(v) and fs.isDir(v) then
      color = colors.red
      writeSize = false
    elseif fs.isReadOnly(v) then
      color = colors.orange
    elseif fs.isDir(v) then -- Can't be read only.
      color = colors.yellow
    end

    if ext == "lua" then
      color = colors.blue
    end
    if ay == h then
      term.scroll(1)
      ay = ay - 1
    end
    if writeSize then
      peclib.prite(ax, ay, v..(" "):rep(sizex-#v)..kbsize.."KB", color, colors.black)
    else
      peclib.prite(ax, ay, v, color, colors.black)
    end
    ay = ay+1
  end

  print()
