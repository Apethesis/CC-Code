local comlib = {}

function comlib.prite(x,y,text,tcolor,bcolor)
    if tcolor == nil then
        tcolor = colors.white
    end
    if bcolor == nil then
        bcolor = colors.black
    end
    term.setCursorPos(x,y)
    term.setTextColor(tcolor)
    term.setBackgroundColor(bcolor)
    term.write(text)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
end -- this is prite

function comlib.update(link,ver)
    local request = http.get(link)
    local version = request.readLine()
    request.close()
    local verNum = tonumber(version:match("= (.+)"))
    if not (ver == verNum) then
        fs.delete(shell.getRunningProgram())
        local request = http.get(link)
        local newver = fs.open(shell.getRunningProgram(),"w")
        newver.write(request.readAll())
        request.close()
        newver.close()
        return true
    end
end

return comlib

