local comlib = {}

function comlib.toBlit(color)
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
    local expect = require("cc.expect")
    expect(1, color, "number")
    return color_hex_lookup[color] or
        string.format("%x", math.floor(math.log(color) / math.log(2)))
end

function comlib.math.tiny()
    return -math.huge
end

function comlib.prite(x,y,text,tcolor,bcolor)
    if tcolor == nil then
        tcolor = "0"
    end
    if bcolor == nil then
        bcolor = "f"
    end
    if type(tcolor) == "number" then
        tcolor = comlib.toBlit(tcolor)
    end
    if type(bcolor) == "number" then
        bcolor = comlib.toBlit(bcolor)
    end
    term.setCursorPos(x,y)
    term.blit(text,tcolor:rep(#text),bcolor:rep(#text))
end -- this is prite

function comlib.encode(tbl)
    local out = tostring(#tbl[#tbl]).."|"
    for k,v in ipairs(tbl) do
        out = out .. v or ""
    end
    return out
end

function comlib.decode(str)
    local len_or,str = str:match("(%d.-)|(.+)")
    local len = #str/len_or
    local out = {}
    for i=1,len do
        out[i] = str:sub(i*len_or-len_or+1,i*len_or)
    end
    return out
end

function comlib.update(link,ver)
    local request = http.get(link)
    if request ~= nil then
        local version = request.readLine()
        local verNum = tonumber(version:match("= (.+)"))
        if ver < verNum then
            local newver = fs.open(shell.getRunningProgram(),"w")
            newver.write(request.readAll())
            request.close()
            newver.close()
            return true
        end
    elseif request == nil then
        return false
    end
    request.close()
end
--[[
    to use comlib.update you need to have a direct link to the latest version
    and "local ver = 1.0" without the quotes, also change the value of ver when
    you update the program.
]]

return comlib
