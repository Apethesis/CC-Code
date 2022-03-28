local ver = 2.6
local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/compaint.lua")
local version = request.readLine()
request.close()
local verNum = tonumber(version:match("= (.+)"))
if not (ver == verNum) then
    fs.delete("./compaint.lua")
    fs.delete("./comlib.lua")
    local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/compaint.lua")
    local newver = fs.open("./compaint.lua","w")
    newver.write(request.readAll())
    request.close()
    newver.close()
    error("ComPaint updated.",0)
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
local comlib = require("comlib")
local map = {}
if fs.exists("/save.cimg") == true then
    local loadsave = fs.open("save.cimg","r")
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
term.clear()
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
    while true do
        if btable[x] and y == 1 then
            colr = btable[x]
        end
        local x,y = term.getSize()
        local ax = x - 17
        comlib.prite(ax,y,"Changed color to "..colr)
    end
end
function draw(_,_,x,y)
    while true do
        if y > 1 then
            comlib.prite(x,y," ",colors.white,btable[colr])
            map[x] = map[x] or {}
            map[x][y] = btable[colr]
            local ex,ey = term.getSize()
            local ax = ex - 17
            comlib.prite(ax,ey,"Drew at x"..x.." y"..y.."        ")
            while eventType == "mouse_drag" do
                local deve, dbut, dx, dy = os.pullEvent("mouse_drag")
                comlib.prite(dx,dy," ",colors.white,btable[colr])
                comlib.prite(ax,ey,"Drew at x"..x.." y"..y.."        ")
                sleep()
                map[dx] = map[dx] or {}
                map[dx][dy] = btable[colr]
            end
        end
    end
end
function sbug()
    while true do
        local x,y = term.getSize()
        local ay = y - 1
        comlib.prite(x,ay,colr)
        sleep(0.1)
    end
end
function save()
    local autosave = fs.open("save.cimg","w")
    local poet = textutils.serialize(map)
    autosave.write(poet)
    autosave.close()
end
function savecheck(_,key,_)
    while true do
        if key == keys.s then
            save()
            local x,y = term.getSize()
            local ax = x - 17
            comlib.prite(ax,y,"Saved                      ")
        end
    end
end
function clearmap(_,key,_)
    while true do
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
		save()
        error("", 0)
    elseif event[1] == "key" then
		
end
