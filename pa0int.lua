local ver = 1.00
term.clear()
-- Most of the locals begin here
local chx = {[colors.white] = "0",[colors.orange] = "1",[colors.magenta] = "2",[colors.lightBlue] = "3",[colors.yellow] = "4",[colors.lime] = "5",[colors.pink] = "6",[colors.gray] = "7",[colors.lightGray] = "8",[colors.cyan] = "9",[colors.purple] = "a",[colors.blue] = "b",[colors.brown] = "c",[colors.green] = "d",[colors.red] = "e",[colors.black] = "f"}

local function toBlit(color)
    if type(color) == "string" then return color end
    return chx[color]
end

local function prite(x,y,text,fg,bg)
    x = x or 1; y = y or 1; text = text or " "; fg = fg or term.getTextColor(); bg = bg or term.getBackgroundColor()
    term.setCursorPos(x,y)
    term.blit(text, toBlit(fg):rep(#text), toBlit(bg):rep(#text))
end

local function createNDarray(n, tbl) 
    tbl = tbl or {} 
    if n == 0 then return tbl end 
    setmetatable(tbl, {__index = function(t, k) 
        local new = createNDarray(n - 1) 
        t[k] = new 
        return new 
    end}) 
    return tbl 
end

local map = createNDarray(2, {})

local args = {...}
local fp = "./save.cimg2"
if args[1] then
    if args[1]:match("[^%.]+$") ~= "cimg2" then
        error("Must be in .cimg2 format",0)
    end
    fp = args[1]
end

local cur = { c = " ", b = "0", f = "0" }

local tx,ty = term.getSize()

-- Loading the save begins here.

if fs.exists(fp) then
    local fl = fs.open(fp,"r")
    local cm = textutils.unserialize(fl.readAll())
    for k1,v1 in pairs(cm) do
        for k2,v2 in pairs(v1) do
            local tbl = {}
            tbl[1] = string.sub(v2,1,1) -- c
            tbl[2] = string.sub(v2,2,2) -- b
            tbl[3] = string.sub(v2,3,3) -- f
            map[k1][k2] = tbl
        end
    end
end

-- General functions that you would use a lot

local function save(_, k, _)
    if k == keys.s then
        local modmap = createNDarray(2, {})
        for k1,v1 in pairs(map) do
            for k2,v2 in pairs(v1) do
                local str = ""..v2[1]..v2[2]..v2[3]
                modmap[k1][k2] = str
            end
        end
        local fl = fs.open(fp,"w")
        fl.write(textutils.serialize(modmap,{compact=true}))
        fl.close()
    end 
end

local function drawMap()
    for k1,v1 in pairs(map) do
        for k2,v2 in pairs(v1) do
            prite(k1,k2,v2[1],v2[3],v2[2])
        end
    end
end

local function draw(e, b, x, y)
    if e ~= "monitor_touch" then
        if b == 1 then
            map[x][y] = {[1] = cur.c, [2] = cur.b, [3] = cur.f}
        else
            map[x][y] = nil
            prite(x,y," ",colors.black,colors.black)
        end
        drawMap()
    else
        map[x][y] = {c = cur.c, b = cur.b, f = cur.f}
        drawMap()
    end
end

local function changeColor(_,k,_)
    if k == keys.k then
        local oldx,oldy = term.getCursorPos()
        term.setCursorPos(tx-2,ty)
        local c = read()
        local ft = {
            c = function(str)
                local a = string.sub(str,3)
                cur.c = a
            end,
            b = function(str)
                local a = string.sub(str,3,3)
                cur.b = a
            end,
            f = function(str)
                local a = string.sub(str,3,3)
                cur.f = a
            end
        }
        if ft[string.sub(c,2,2)] then
            ft[string.sub(c,2,2)](c)
        end
        term.setCursorPos(oldx,oldy)
        term.clear()
        drawMap()
    end
end

local function event_loop()
    while true do
        local ev = table.pack(os.pullEvent())
        if ev[1] == "mouse_click" or ev[1] == "mouse_drag" then
            draw(table.unpack(ev))
        elseif ev[1] == "key" then
            save(table.unpack(ev))
            changeColor(table.unpack(ev))
        end
    end
end

drawMap()

local ok, err = pcall(event_loop)
print(err)
