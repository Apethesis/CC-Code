local ver = 4.1.1
local args = {...}
local svfl = "./save.cimg"
if args[1] ~= nil then
    if args[1]:match("[^%.]+$") ~= "cimg" then
        error("Must be in .cimg format",0)
    end
    svfl = args[1]
end
if not fs.exists("./peclib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/peclib.lua")
    local htf = fs.open("./peclib.lua","w")
    htf.write(htg.readAll())
    htf.close()
    htg.close()
end
local peclib = require "peclib"
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
local tx,ty = term.getSize()
print("This program is still in beta, and isn't stable.")
print("Do you wish to continue? (yes/no)")
local beta = read()
local guiHidden = false
if http.get("https://github.com/Apethesis/CC-Code/raw/main/pecpaint.lua").readAll() ~= fs.open("pecpaint.lua","r").readAll() then
    print("There is a new version of this program available, do you wish to update? (yes/no)")
    local update = string.lower(read())
    if update == "yes" then
        peclib.update("https://github.com/Apethesis/CC-Code/raw/main/pecpaint.lua",ver)
    end
end
if beta == "no" then
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
            peclib.prite(x,y," ",peclib.toBlit(colors.white),data)
        end
    end
end
local colr = colors.white
for i = 1,16 do
    peclib.prite(i,1," ",peclib.toBlit(colors.white),peclib.toBlit(btable[i]))
end
local function clrbutton(_,_,x,y)
    if btable[x] and y == 1 and guiHidden == false then
        colr = peclib.toBlit(btable[x])
    end
    local ax = tx - 17
    peclib.prite(ax,ty,"Changed color to "..colr)
end
local function draw(_,button,x,y)
    if button == 1 and guiHidden == false then
        if y > 1 then
            peclib.prite(x,y," ",peclib.toBlit(colors.white),colr)
            map[x] = map[x] or {}
            map[x][y] = colr
            local ax = tx - 17
            peclib.prite(ax,ty,"Drew at x"..x.." y"..y.."        ")
        end
    elseif button == 2 and guiHidden == false then
        if y > 1 then
            peclib.prite(x,y," ")
            map[x] = map[x] or {}
            map[x][y] = peclib.toBlit(colors.black)
            local ax = tx - 17
            peclib.prite(ax,ty,"Erased x"..x.." y"..y.."        ")
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
        peclib.prite(ax,ty,"Saved                      ")
    end
end
local function clearmap(_,key,_)
    if key == keys.c and guiHidden == false then
        map = {}
        
        term.clear()
        for i = 1,16 do
            peclib.prite(i,1," ",peclib.toBlit(colors.white),peclib.toBlit(btable[i]))
        end
        local ax = tx - 17
        peclib.prite(ax,ty,"Cleared                      ")
        peclib.prite(tx-14,1,"PecPaint v"..ver)
        save()
    end
end
local function fillBackground(_,key,_)
    if key == keys.f and guiHidden == false then
        for a = 1,tx do
            for b = 2,ty do
                map[a] = map[a] or {}
                map[a][b] = colr
                peclib.prite(a,b," ",peclib.toBlit(colors.white),colr)
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
                peclib.prite(x,y," ",peclib.toBlit(colors.white),data)
            end
        end
        guiHidden = true
    end
    if key == keys.h and guiHidden == true then
        peclib.prite(tx-14,1,"PecPaint v"..ver)
        for i = 1,16 do
            peclib.prite(i,1," ",peclib.toBlit(colors.white),peclib.toBlit(btable[i]))
        end
        guiHidden = false
    end
end
peclib.prite(tx-14,1,"PecPaint v"..ver)
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
    sleep()
end
