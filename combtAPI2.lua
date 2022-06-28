local api = {}
local functable = {}

-- Just defining some useful functions
local function to_blit(c)
	return ("%x"):format(select(2, math.frexp(c))-1)
end

local function prite(x, y, text, tcolor, bcolor)
    x = x or 0 y = y or 0 text = text or "" tcolor = tcolor or "0" bcolor = bcolor or "f" tcolor = type(tcolor) == "number" and to_blit(tcolor) or tcolor bcolor = type(bcolor) == "number" and to_blit(bcolor) or bcolor
    term.setCursorPos(x, y)
    term.blit(text, tcolor:rep(#text), bcolor:rep(#text))
end

local function writeCentered(x,y,w,h,text,bg,fg)
    term.setCursorPos(math.ceil(w/2-#text/2+x),math.ceil(h/2)+y-1)
    term.blit(text,fg:rep(#text),bg:rep(#text))
end

local function mbIsWithin(x,y,start_x,start_y,width,height)
    return x >= start_x and x < start_x+width and y >= start_y and y < start_y+height
end

-- The start of all, api.create()
function api.create(terme)
    functable.term = terme or term.current()
    return setmetatable({ data = {} },{__index = functable})
end

-- Basic modification and creation functions
function functable:make(mntl)
    if type(mntl.color) == "number" then mntl.color = to_blit(mntl.color) end
    if type(mntl.textColor) == "number" then mntl.textColor = to_blit(mntl.textColor) end
    if not mntl.visible then mntl.visible = true end
    self.data[mntl.name] = mntl
end

function functable:delete(name)
    self.data[name] = nil
end

function functable:modify(mntl)
    for k,v in pairs(mntl) do
        self.data[mntl.name][k] = v
    end
end

-- Drawing n' stuff
function functable:draw(name)
    local tbl = self.data[name]
    if not tbl.visible then return end
    for i=tbl.y,tbl.y+tbl.height-1 do
        prite(tbl.x,i,(" "):rep(tbl.width),tbl.textColor,tbl.color)
    end
    writeCentered(tbl.x,tbl.y,tbl.width,tbl.height,tbl.text,tbl.color,tbl.textColor)
end

function functable:execute(func)
    func = func or function()
        os.epoch()
        sleep(5)
    end
    local function checkin()
        while true do
            local event = {os.pullEvent("mouse_click")}
            for k,v in pairs(self.data) do
                if mbIsWithin(event[3],event[4],v.x,v.y,v.width,v.height) and v.visible then
                    v.on_click()
                end
            end
        end
    end
    while true do
        parallel.waitForAny(checkin,func)
    end
end
return api
