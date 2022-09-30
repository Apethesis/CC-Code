local pearlin = {}

function pearlin.fade(t)
    return ((6*t - 15)*t + 10)*t*t*t
end

function pearlin.lerp(t,a1,a2)
    return a1 + t*(a2-a1)
end

vector.constructor = function(self,x,y)
    self.x = x
    self.y = y
end

vector.dot = function(self, o)
    return self.x*o.x + self.y*o.y
end

function pearlin.getConstVector(v)
    local h = bit32.band(v,3)
    if h == 0 then
        return vector.new(1.0,1.0)
    elseif h == 1 then
        return vector.new(-1.0, 1.0)
    elseif h == 2 then
        return vector.new(-1.0, -1.0)
    else
        return vector.new(1.0,-1.0)
    end
end

function pearlin.createNDarray(n, tbl) 
    tbl = tbl or {} 
    if n == 0 then return tbl end 
    setmetatable(tbl, {__index = function(t, k) 
        local new = pearlin.createNDarray(n - 1) 
        t[k] = new 
        return new 
    end}) 
    return tbl 
end

function pearlin.shuffle(tbl)
    local temp
    for e=(#tbl-1),1,-1 do
        local index = math.floor((math.random()*(e-1))+0.5)
        temp = tbl[e]
        tbl[e] = tbl[index]
        tbl[index] = temp
    end
end

function pearlin.makeperm()
    local P = {}
    for i=0,256 do
        table.insert(P,i)
    end
    pearlin.shuffle(P)
    for i=0,256 do
        table.insert(P,i)
    end
    return P
end
local P = pearlin.makeperm()
function pearlin.noise2d(x,y)
    local X = bit32.band(math.floor(x),255)
    local Y = bit32.band(math.floor(y),255)
    local xf = x-math.floor(x)
    local yf = y-math.floor(y)
    local topRight = vector.new(xf-1.0, yf-1.0)
    local topLeft = vector.new(xf, yf-1.0)
    local bottomRight = vector.new(xf-1.0, yf)
    local bottomLeft = vector.new(xf,yf)
    local valueTopRight = P[P[X+1]+Y+1]
    local valueTopLeft = P[P[X]+Y+1]
    local valueBottomRight = P[P[X+1]+Y]
    local valueBottomLeft = P[P[X]+Y]
    local dotTopRight = topRight:dot(pearlin.getConstVector(valueTopRight))
    local dotTopLeft = topLeft:dot(pearlin.getConstVector(valueTopLeft))
    local dotBottomRight = bottomRight:dot(pearlin.getConstVector(valueBottomRight))
    local dotBottomLeft = bottomLeft:dot(pearlin.getConstVector(valueBottomLeft))
    local u = pearlin.fade(xf)
    local v = pearlin.fade(yf)
    return pearlin.lerp(u, pearlin.lerp(v, dotBottomLeft, dotTopLeft), pearlin.lerp(v, dotBottomRight, dotTopRight))
end

function pearlin.noise(x,y,amp)
    local tbl = pearlin.createNDarray(2)
    local oiledupgermanguystryingtowrestleme = amp or 0.01
    for a=0,y do
        for b=0,x do
            local n = ((pearlin.noise2d(a*oiledupgermanguystryingtowrestleme,b*oiledupgermanguystryingtowrestleme)) + 1) * 0.5
            n = n + 1.0
            n = n * 0.5
            tbl[a][b] = n
            os.queueEvent("cap") os.pullEvent("cap")
        end
    end
    return tbl
end

return pearlin
