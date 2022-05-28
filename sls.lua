local ver = 1.0

require("updater")("https://raw.githubusercontent.com/Apethesis/CC-Code/main/sls.lua", ver)

-- It stands for "Shitty LiSt"

-- bruh git please sign my commit

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
    term.setTextColor(color)
    if writeSize then
      print(v..(" "):rep(sizex-#v)..kbsize.."KB")
    else
      print(v)
    end
  end
term.setTextColor(colors.white)