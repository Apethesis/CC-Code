local api = {}
local functable = {}

-- Just defining some useful functions
local function to_blit(c)
	return ("%x"):format(select(2, math.frexp(c))-1)
end

local function prite(x, y, text, tcolor, bcolor, trm)
    trm = trm or term.current() x = x or 0 y = y or 0 text = text or "" tcolor = tcolor or "0" bcolor = bcolor or "f" tcolor = type(tcolor) == "number" and to_blit(tcolor) or tcolor bcolor = type(bcolor) == "number" and to_blit(bcolor) or bcolor
    trm.setCursorPos(x, y)
    trm.blit(text, tcolor:rep(#text), bcolor:rep(#text))
end

local function writeCentered(x,y,w,h,text,bg,fg,trm)
    trm = trm or term.current()
    trm.setCursorPos(math.ceil(w/2-#text/2+x),math.ceil(h/2)+y-1)
    trm.blit(text,fg:rep(#text),bg:rep(#text))
end

local function mbIsWithin(x,y,start_x,start_y,width,height)
    return x >= start_x and x < start_x+width and y >= start_y and y < start_y+height
end

-- The start of all, api.create()
function api.create(terme,x,y,width,height)
    terme = terme or term.current()
    x = x or 1 y = y or 1 width, height = term.getSize() 
    terme = window.create(terme,x,y,width,height)
    return setmetatable({ data = {}, tasks = {}, term = terme },{__index = functable, __add = function(self,other)
        if type(other) == "table" then
            for k,v in pairs(other) do
                table.insert(self,#self+1,v)
            end
        else
            table.insert(self,#self+1,other)
        end
    end})
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
    if type(mntl.color) == "number" then mntl.color = to_blit(mntl.color) end
    if type(mntl.textColor) == "number" then mntl.textColor = to_blit(mntl.textColor) end
    if not mntl.visible then mntl.visible = true end
    for k,v in pairs(mntl) do
        self.data[mntl.name][k] = v
    end
    functable:draw(mntl.name)
end

-- Drawing n' stuff
function functable:draw(name)
    local tbl = self.data[name]
    if not tbl.visible then return end
    for i=tbl.y,tbl.y+tbl.height-1 do
        prite(tbl.x,i,(" "):rep(tbl.width),tbl.textColor,tbl.color,self.term)
    end
    writeCentered(tbl.x,tbl.y,tbl.width,tbl.height,tbl.text,tbl.color,tbl.textColor,self.term)
end

function functable:schedule(func)
    table.insert(self.tasks,#self.tasks+1,{coro = coroutine.create(func)})
end

function functable:execute(func)
    func = func or function()
        os.epoch()
        sleep(3)
    end
    local function checkin()
        while true do
            local event = table.pack(os.pullEvent())
            if event[1] == "mouse_click" then
                for k,v in pairs(self.data) do
                    if mbIsWithin(event[3],event[4],v.x,v.y,v.width,v.height) and v.visible then
                        v.on_click(self)
                    end
                end
            end
            for k,v in pairs(self.tasks) do
                if coroutine.status(v.coro) == "dead" then
                    self.tasks[k] = nil
                else
                    if v.filter == nil or v.filter == event[1] then
                        local ok, filter = coroutine.resume(v.coro,table.unpack(event,1,event.n),self)
                        if ok then
                            v.filter = filter
                        end 
                    end
                end
            end
        end
    end
    while true do
        parallel.waitForAny(checkin,func)
    end
end

return api