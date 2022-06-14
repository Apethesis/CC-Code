--- The main table of functions
-- @module peclib
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

--- Converts a "colors" value into a blit value
-- @param color "colors" value (number)
-- @return blit value (string)
-- @usage local peclib = require("peclib")
function peclib.toBlit(color)
    expect(1, color, "number")
    return color_hex_lookup[color] or string.format("%x", math.floor(math.log(color) / math.log(2)))
end

--- My custom read function
-- @return text that was inputted (string)
function peclib.read()
    local entr = false
    local stre = ""
    while not entr do
        local evnt = table.pack(os.pullEvent())
        if evnt[2] == keys.enter and evnt[1] == "key" then
            entr = true
        elseif evnt[1] == "char" then
            stre = stre..evnt[2]
        elseif evnt[1] == "key" and evnt[2] == keys.backspace then
            stre = stre:sub(1,-2)
        end
    end
    return stre
end

--- prite (PrintWrites) to a specific location on the screen
-- @param x x value (number)
-- @param y y value (number)
-- @param text text to be written (string)
-- @param tcolor colors or blit value to be used as text color
-- @param bcolor colors or blit value to be used as background color
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
end

--- update. compares 2 numbers and if the one from the link is higher it updates the program
-- @param link link to the raw text version of your program
-- @param ver version of the program, must be a number or float
function peclib.update(link, ver)
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

--- basically shell.run("wget link") in library form
-- @param link raw link to the text version of your program
-- @param filename path or filename to the file
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
