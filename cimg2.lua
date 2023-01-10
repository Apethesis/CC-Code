local cimg2 = {}
local ftblr = {}
local ftblw = {}
local chx = {[colors.white] = "0",[colors.orange] = "1",[colors.magenta] = "2",[colors.lightBlue] = "3",[colors.yellow] = "4",[colors.lime] = "5",[colors.pink] = "6",[colors.gray] = "7",[colors.lightGray] = "8",[colors.cyan] = "9",[colors.purple] = "a",[colors.blue] = "b",[colors.brown] = "c",[colors.green] = "d",[colors.red] = "e",[colors.black] = "f"}

local function toBlit(color)
    if type(color) == "string" then return color end
    return chx[color]
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

function cimg2.load(flpath, mode)
  if fs.exists(flpath) and flpath:match("[^%.]+$") == "cimg2" and mode == 0 then
    local fl = fs.open(flpath,"r")
    local map = textutils.unserialize(fl.readAll()) fl.close()
    return setmetatable({map = map}, {__index = ftblr})
  elseif flpath:match("[^%.]+$") == "cimg2" and mode == 1 then
    return setmetatable({fl = fs.open(flpath,"w"), map = createNDarray(2)}, {__index = ftblw})
  elseif not fs.exists(flpath) and mode == 0 then
    error("File does not exist.",0)
  elseif not flpath:match("[^%.]+$") == "cimg2" then
    error("File must have .cimg2 extension.",0)
  end
end

function ftblr:getSize()
  local map = self.map -- for that tiny performance increase
  return #map[#map],#map
end

function ftblr:readPixel(x,y)
  local map = self.map
  local rtbl = {}
  rtbl[1] = map[x][y]:sub(1,1) rtbl[2] = map[x][y]:sub(2,2) rtbl[3] = map[x][y]:sub(3,3) 
  return rtbl
end

function ftblw:close()
  self.fl.write(textutils.serialize(self.map,{ compact = true }))
  self.fl.close()
end

function ftblw:setPixel(x,y,c,b,f)
  local map = self.map
  b = toBlit(b) f = toBlit(f)
  map[x][y] = c..b..f
end

return cimg2
