-- It stands for "Shitty LiSt"

-- No more peclib.
-- Cry about it.

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
local ax = 1
local ay = cy
for k,v in pairs(ftbl) do
    local ext = v:match("[^%.]+$")
    local filesize = fs.getSize(v)
    local kbsize = string.sub(tostring(filesize / 1024), 1, 4)
    local writeSize = true
    if fs.isReadOnly(v) and fs.isDir(v) then
      term.setTextColor(colors.red)
      writeSize = false
    elseif fs.isReadOnly(v) then
      term.setTextColor(colors.orange)
    elseif fs.isDir(v) then -- Can't be read only.
      term.setTextColor(colors.yellow)
      writeSize = false
    end

    if ext == "lua" then
      term.setTextColor(colors.blue)
    elseif ext ~= v then
      term.setTextColor(colors.white)
    end
    if writeSize then
      print(v..string.rep(" ", sizex-#v)..kbsize.."KB")
    else
      print(v)
    end
    term.setTextColor(colors.white)
end
