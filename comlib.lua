local comlib = {}

function comlib.toBlit(color)
    expect(1, color, "number")
    return color_hex_lookup[color] or
        string.format("%x", math.floor(math.log(color) / math.log(2)))
end

function comlib.priteBlit(x,y,text,tcolor,bcolor)
    tcolor = tcolor and tostring(tcolor) or "0"
    bcolor = bcolor and tostring(bcolor) or "f"
    term.setCursorPos(x,y)
    term.blit(text,tcolor:rep(#text),bcolor:rep(#text))
end -- this is prite

function comlib.prite(x,y,text,tcolor,bcolor)
    tcolor = tcolor or colors.white
    bcolor = bcolor or colors.black
    term.setCursorPos(x,y)
    term.setTextColor(tcolor)
    term.setBackgroundColor(bcolor)
    term.write(text)
end

function comlib.update(link,ver)
    local request = http.get(link)
    local version = request.readLine()
    request.close()
    local verNum = tonumber(version:match("= (.+)"))
    if ver < verNum then
        fs.delete(shell.getRunningProgram())
        local request = http.get(link)
        local newver = fs.open(shell.getRunningProgram(),"w")
        newver.write(request.readAll())
        request.close()
        newver.close()
        return true
    end
end
--[[
    to use comlib.update you need to have a direct link to the latest version
    and "local ver = 1.0" without the quotes, also change the value of ver when
    you update the program.
]]

return comlib
