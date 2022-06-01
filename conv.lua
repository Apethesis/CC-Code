local args = {...}
local toBlit = require("toBlit"); -- There's a semicolon here now. Suffer.
args[1] = args[1] or "./save.cimg"
args[2] = args[2] or "./save.cimg2"
args[3] = args[3] or "cimg"
args[4] = args[4] or "cimg2"
local sv1 = fs.open(args[1],"r")
local sv2 = fs.open(args[2],"w")
local rsv1 = sv1.readAll()
sv1.close()
local map = textutils.unserialize(rsv1)
local smap = {}
local tx,ty = term.getSize()
local function getIMGSize(array) 
    local minx, maxx = math.huge, -math.huge 
    local miny,maxy = math.huge, -math.huge 
    for x,yList in pairs(array) do 
        minx, maxx = math.min(minx, x), math.max(maxx, x) 
        for y,_ in pairs(yList) do 
            miny, maxy = math.min(miny, y), math.max(maxy, y) 
        end 
    end 
    return math.abs(minx)+maxx,math.abs(miny)+maxy 
end
if args[3] == "cimg" and args[4] == "cimg2" then
    local winder = window.create(term.current(),1,1,term.current().getSize())
    local curTerm = term.current()
    term.redirect(winder)
    for x,_temp in pairs(map) do
        for y,data in pairs(_temp) do
	    term.setCursorPos(x, y)
	    term.blit(" ", "0" --[[Compec you dementia having ass colors.white is 0]], data)
        end
    end
    term.redirect(curTerm)
    for i=1,ty do
        local _,_,data = winder.getLine(i)
        smap[i] = data
    end
elseif args[3] == "cimg" and args[4] == "nimg" then
    for x,_temp in pairs(map) do
        for y,data in pairs(_temp) do
	        term.setCursorPos(x, y)
            term.blit(" ", "0", data)
        end
    end
    smap["offset"] = {5, 13, 11, 4}
    for a=1,tx do
        for b=1,ty do
            local text,tc,bc = winder.getLine(b)
            smap[a] = smap[a] or {}
            smap[a][b] = {
                ["s"] = text:sub(a,a),
                ["b"] = bc:sub(a,a),
                ["t"] = tc:sub(a,a)
            }
        end
    end
elseif args[3] == "blbfor" and args[4] == "cimg" then
    local blb = require("blbfor")
    local image = blb.open(args[1],"r")
    smap["offset"] = {5, 13, 11, 4}
    for x=1,image.width do
        for y=1,image.height do
            local _,_,data = image:get_pixel(x,y,true)
            smap[x] = smap[x] or {}
            smap[x][y] = data
        end
    end
elseif args[3] == "cimg" and args[4] == "blbfor" then
    local blb = require("blbfor")
    local wi,hi = getIMGSize(map)
    local image = blb.open(args[2],"w",wi,hi)
    for x=1,wi do
        for y=1,hi do
            if map[x] and map[x][y] then
                local thng = 2^tonumber(map[x][y],16)
                image:set_pixel(x,y," ",colors.white,thng)
            end
        end
    end
    image:close()
elseif args[3] == "nimg" and args[4] == "blbfor" then
    local blb = require("blbfor")
    local wi,hi = getIMGSize(map)
    local image = blb.open(args[2],"w",wi,hi)
    for x=1,wi do
        for y=1,hi do
            if map[x] and map[x][y] then
                local thng = 2^tonumber(map[x][y]["b"],16)
                image:set_pixel(x,y,map[x][y]["s"],map[x][y]["t"],thng)
            end
        end
    end
elseif args[3] == "nimg" and args[4] == "cimg" then
    for x,_temp in pairs(map) do
        for y,data in pairs(_temp) do
            smap[x][y] = {
                ["s"] = " ",
                ["b"] = data,
                ["t"] = "0"
            }
        end
    end
end
if args[4] ~= "blbfor" then
    sv2.write(textutils.serialize(smap,{ compact = true }))
    sv2.close()
    term.clear()
else
    sv2.close()
    term.clear()
end
