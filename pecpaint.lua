local ver = 4.12
local args = {...}
local svfl = "./save.cimg"
if args[1] ~= nil then
    if args[1]:match("[^%.]+$") ~= "cimg" then
        error("Must be in .cimg format",0)
    end
    svfl = args[1]
end

local btable = {
    [1] = colors.white,
    [2] = colors.orange,
    [3] = colors.magenta,
    [4] = colors.lightBlue,
    [5] = colors.yellow,
    [6] = colors.lime,
    [7] = colors.pink,
    [8] = colors.gray,
    [9] = colors.lightGray,
    [10] = colors.cyan,
    [11] = colors.purple,
    [12] = colors.blue,
    [13] = colors.brown,
    [14] = colors.green,
    [15] = colors.red,
    [16] = colors.black
}

local blitTable = {}
local chars = "0123456789abcdef"
for i=0,15 do
    blitTable[2^i] = chars:sub(i+1,i+1)
end

local function toBlit(color)
    return blitTable[color]
end

local tx,ty = term.getSize()
print("This program is still in beta, and isn't stable.")
print("Do you wish to continue? (yes/no)")
local beta = read()
local guiHidden = false

require("updater")("https://raw.githubusercontent.com/TotallyNotVirtIO/Peclib-less-Compec-Code/main/pecpaint.lua", ver)

if beta:sub(1,1):lower() == "n" then
    os.queueEvent("terminate")
end
term.clear()
local map = {}
if fs.exists(svfl) then
    local loadsave = fs.open(svfl,"r")
    local msave = textutils.unserialize(loadsave.readAll())
    map = msave
    loadsave.close()
    term.clear()
    for x,_temp in pairs(map) do
        for y,data in pairs(_temp) do
            term.setCursorPos(x, y)
            term.blit(" ", toBlit(colors.white), data)
        end
    end
end
local colr = "0"
for i = 1,16 do
    term.setCursorPos(i, 1)
    term.blit(" ", toBlit(colors.white), toBlit(btable[i]) or "f")
end
local function clrbutton(_,_,x,y)
    if btable[x] and y == 1 and guiHidden == false then
        colr = toBlit(btable[x])
    end
end
local function draw(_,button,x,y)
    if button == 1 and guiHidden == false then
        if y > 1 then
            term.setCursorPos(x, y)
            term.blit(" ", toBlit(colors.white), colr)
            map[x] = map[x] or {}
            map[x][y] = colr
            local ax = tx - 17
        end
    elseif button == 2 and guiHidden == false then
        if y > 1 then
            term.setCursorPos(x, y)
            term.blit(" ", "0", "f")
            map[x] = map[x] or {}
            map[x][y] = toBlit(colors.black)
            local ax = tx - 17
        end
    end
end
local function save()
    local autosave = fs.open(svfl,"w")
    local poet = textutils.serialize(map,{ compact = true })
    autosave.write(poet)
    autosave.close()
end
local function savecheck(_,key,_)
    if key == keys.s and guiHidden == false then
        save()
        local ax = tx - 17
        term.setCursorPos(ax, ty)
        write("Saved" .. (" "):rep(22))
    end
end
local function clearmap(_,key,_)
    if key == keys.c and guiHidden == false then
        map = {}
        
        term.clear()
        term.setCursorPos(1,1)
        for i = 1,16 do
            term.blit(" ", toBlit(colors.white), toBlit(btable[i]))
        end
        local ax = tx - 17
        term.setCursorPos(ax,ty)
        write("Cleared" .. (" "):rep(22))
        term.setCursorPos(tx-14, 1)
        print(string.format("PecPaint v%s", ver))
        save()
    end
end
local function fillBackground(_,key,_)
    if key == keys.f and guiHidden == false then
        for a = 1,tx do
            for b = 2,ty do
                map[a] = map[a] or {}
                map[a][b] = colr
                term.setCursorPos(a, b)
                term.blit(" ", toBlit(colors.white), colr)
            end
        end
    end
end
local function hideGui(_,key,_)
    if key == keys.h and guiHidden == false then
        save()
        term.clear()
        for x,_temp in pairs(map) do
            for y,data in pairs(_temp) do
                term.setCursorPos(x, y)
                term.blit(" ", toBlit(colors.white), data)
            end
        end
        guiHidden = true
    end
    if key == keys.h and guiHidden == true then
        term.setCursorPos(tx-14, 1)
        write("PecPaint v"..ver)
        for i = 1,16 do
            term.setCursorPos(i, 1)
            term.blit(" ", toBlit(colors.white), toBlit(btable[i]))
        end
        guiHidden = false
    end
end
term.setCursorPos(tx-14, 1)
write("PecPaint v"..ver)
while true do
	local event = table.pack(os.pullEventRaw())
    if event[1] == "mouse_click" then
        draw(table.unpack(event))
        clrbutton(table.unpack(event))
    elseif event[1] == "mouse_drag" then
        draw(table.unpack(event))
    elseif event[1] == "terminate" then
        save() 
        term.clear()
        term.setCursorPos(1, 1)
        error("", 0)
    elseif event[1] == "key" then
        clearmap(table.unpack(event))
        hideGui(table.unpack(event))
	    savecheck(table.unpack(event))
        fillBackground(table.unpack(event))
	end
end
