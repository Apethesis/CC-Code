local peclib = {}
local expect = require("cc.expect")
local color_hex_lookup = {
    [colors.white] = "0",
    [colors.orange] = "1",
    [colors.magenta] = "2",
    [colors.lightBlue] = "3",
    [colors.yellow] = "4",
    [colors.lime] = "5",
    [colors.pink] = "6",
    [colors.gray] = "7",
    [colors.lightGray] = "8",
    [colors.cyan] = "9",
    [colors.purple] = "a",
    [colors.blue] = "b",
    [colors.brown] = "c",
    [colors.green] = "d",
    [colors.red] = "e",
    [colors.black] = "f"
}

function peclib.toBlit(color) -- peclib.toBlit(a colors value)
    expect(1, color, "number")
    return color_hex_lookup[color] or
        string.format("%x", math.floor(math.log(color) / math.log(2)))
end

function peclib.prite(x, y, text, tcolor, bcolor) -- peclib.prite(x,y,text,text color,background color)
    x = x or 0
    y = y or 0
    text = text or ""
    tcolor = tcolor or "0"
    bcolor = bcolor or "f"
    tcolor = type(tcolor) == "number" and peclib.toBlit(tcolor) or tcolor
    bcolor = type(bcolor) == "number" and peclib.toBlit(bcolor) or bcolor
    term.setCursorPos(x, y)
    term.blit(text, tcolor:rep(#text), bcolor:rep(#text))
end -- this is prite

function peclib.encode(tbl) -- peclib.encode(a table to encode)
    local out = tostring(#tbl[#tbl]) .. "|"
    for k, v in ipairs(tbl) do out = (out .. v) or "" end
    return out
end

function peclib.decode(str) -- peclib.decode(a string to decode)
    local len_or, str = str:match("(%d.-)|(.+)")
    local len = #str / len_or
    local out = {}
    for i = 1, len do out[i] = str:sub(i * len_or - len_or + 1, i * len_or) end
    return out
end

function peclib.update(link, ver) -- peclib.update(a link to the raw file, and your version variable. must be a number)
    local request = http.get(link)
    if request ~= nil then
        local txt = request.readAll()
        local verNum = tonumber(txt:match("ver = (.-)\n"))
        request.close()
        if ver < verNum then
            local newver = fs.open(shell.getRunningProgram(), "w")
            newver.write(txt)
            newver.close()
            return true
        end
    end
    return false
end

function peclib.wget(link,filename)
    local request = http.get(link)
    if request ~= nil then
        local txt = request.readAll()
        local fl = fs.open("./"..filename,"w")
        fl.write(txt)
        return true
    end
    return false
end

return peclib
