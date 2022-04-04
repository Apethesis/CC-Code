local comlib = {}
local color_hex_lookup = {}

function comlib.toBlit(color)
    if color == nil or type(color) ~= "number" then
        return nil
    end
    return color_hex_lookup[color] or string.format("%x", math.floor(math.log(color) / math.log(2)))
end

for i,v in pairs(colors) do
    if type(v) == "number" then
        color_hex_lookup[i] = comlib.toBlit(v)
    end
end

function comlib.prite(x, y, text, tcolor, bcolor)
    x = x or 0
    y = y or 0
    text = text or ""
    tcolor = tcolor or "0"
    bcolor = bcolor or "f"
    tcolor = type(tcolor) == "number" and comlib.toBlit(tcolor) or tcolor
    bcolor = type(bcolor) == "number" and comlib.toBlit(bcolor) or bcolor
    term.setCursorPos(x, y)
    term.blit(text, tcolor:rep(#text), bcolor:rep(#text))
end -- this is prite

function comlib.encode(tbl)
    local out = tostring(#tbl[#tbl]) .. "|"
    for k, v in ipairs(tbl) do out = (out .. v) or "" end
    return out
end

function comlib.decode(str)
    local len_or, str = str:match("(%d.-)|(.+)")
    local len = #str / len_or
    local out = {}
    for i = 1, len do out[i] = str:sub(i * len_or - len_or + 1, i * len_or) end
    return out
end

function comlib.wget(link,filename)
	local req = http.get(link)
	local fl = fs.open("./"..filename,"w")
	fl.write(req.readAll())
	req.close()
	fl.close()
end

function comlib.update(link, ver)
    local request = http.get(link)
    if request ~= nil then
        local txt = request.readAll()
        local verNum = tonumber(txt:match("ver = (.-)\n"))
        request.close()
        if ver < verNum then
            comlib.wget(link,shell.getRunningProgram())
            return true
        end
    end
    return false
end
--[[
    to use comlib.update you need to have a direct link to the latest version
    and "local ver = 1.0" without the quotes, also change the value of ver when
    you update the program.
]]

return comlib
