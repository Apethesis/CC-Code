local ver = 3.3
local comlib = require "comlib"
if comlib.update("https://raw.githubusercontent.com/Apethesis/CC-Code/main/compaint.lua",ver) == true then
	error("Update Complete",0)
end
print("This program is still in beta, and isn't stable.")
print("Do you wish to continue? (yes/no)")
local beta = read()
if beta == "no" then
    os.queueEvent("terminate")
end
if not fs.exists("./comlib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comlib.lua")
    local htf = fs.open("./comlib.lua","w")
    local x,y = term.getSize()
    local ax = x - 17
    htf.write(htg.readAll())
    htf.close()
    term.setCursorPos(ax,y)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.write("comlib downloaded")
    print(" ")
    term.setCursorPos(1,y)
    htg.close()
end
local map = {}
if fs.exists("./save.cimg") == true then
    local loadsave = fs.open("./save.cimg","r")
    local msave = textutils.unserialize(loadsave.readAll())
    map = msave
    loadsave.close()
    term.clear()
    for x,_temp in pairs(map) do
        for y,data in pairs(_temp) do
            comlib.prite(x,y," ",colors.white,data)
        end
    end
end
local colr = colors.white
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
for i = 1,16 do
    comlib.prite(i,1," ",colors.white,btable[i])
end
function clrbutton(_,_,x,y)
    if btable[x] and y == 1 then
        colr = btable[x]
    end
    local tx,ty = term.getSize()
    local ax = tx - 17
    comlib.prite(ax,y,"Changed color to "..colr)
end
function draw(_,_,x,y)
    if y > 1 then
        comlib.prite(x,y," ",colors.white,colr)
        map[x] = map[x] or {}
        map[x][y] = colr
        local ex,ey = term.getSize()
        local ax = ex - 17
        comlib.prite(ax,ey,"Drew at x"..x.." y"..y.."        ")
    end
end
function sbug()
    local x,y = term.getSize()
    local ay = y - 1
    comlib.prite(x,ay,colr)
    sleep(0.1)
end
function save()
    local autosave = fs.open("./save.cimg","w")
    local poet = textutils.serialize(map)
    autosave.write(poet)
    autosave.close()
end
function savecheck(_,key,_)
    if key == keys.s then
        save()
        local x,y = term.getSize()
        local ax = x - 17
        comlib.prite(ax,y,"Saved                      ")
    end
end
function clearmap(_,key,_)
    if key == keys.c then
        map = {}
        local x,y = term.getSize()
        term.clear()
        for i = 1,16 do
            comlib.prite(i,1," ",colors.white,btable[i])
        end
        local ax = x - 17
        comlib.prite(ax,y,"Cleared                      ")
        comlib.prite(x-12,1,"ComPaint v"..ver)
        save()
    end
end
local tx,ty = term.getSize()
comlib.prite(tx-12,1,"ComPaint v"..ver)
while true do
	--[[
    local _, key, _ = os.pullEvent("key")
	local event, button, x, y = os.pullEvent("mouse_click")
	local eventType, _, _, _, _ = os.pullEvent()
    parallel.waitForAny(clrbutton,draw,sbug,termcheck,savecheck,clearmap)
    sleep(0.1)
	--]]
	local event = table.pack(os.pullEventRaw())
    if event[1] == "mouse_click" then
        draw(table.unpack(event))
        clrbutton(table.unpack(event))
    elseif event[1] == "mouse_drag" then
        draw(table.unpack(event))
    elseif event[1] == "terminate" then
        term.clear()
        term.setCursorPos(1, 1)
        error("", 0)
    elseif event[1] == "key" then
		clearmap(table.unpack(event))
		savecheck(table.unpack(event))
	end
    sleep()
end
