local combtAPI = {}
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

function combtAPI.mbIsWithin(x,y,start_x,start_y,width,height)
    return x >= start_x and x < start_x+width and y >= start_y and y < start_y+height
end

function combtAPI.writeCentered(x,y,w,h,text,bg,fg)
    term.setCursorPos(math.ceil(w/2-#text/2+x),math.ceil(h/2)+y-1)
    term.blit(text,fg:rep(#text),bg:rep(#text))
end

function combtAPI.makeButton(maintbl)
    expect(1, maintbl, "table")
    expect(2, maintbl.x, "number")
    expect(3, maintbl.y, "number")
    expect(4, maintbl.width, "number")
    expect(5, maintbl.height, "number")
    expect(6, maintbl.text, "string", "nil")
    expect(7, maintbl.textColor, "string", "number", "nil")
    expect(8, maintbl.color, "string", "number", "nil")
    expect(9, maintbl.buttonName, "string")
    combtTBL = combtTBL or {}
    local textColorC = maintbl.textColor
    local colorC = maintbl.color
    maintbl.textColor = maintbl.textColor or "0"
    maintbl.color = maintbl.color or "d"
    if type(maintbl.textColor) == "number" then
        maintbl.textColor = color_hex_lookup[maintbl.textColor]
    end
    if type(maintbl.color) == "number" then
        maintbl.color = color_hex_lookup[maintbl.color]
    end
    maintbl.text = maintbl.text or ""
    combtTBL[maintbl.buttonName] = {
        x = maintbl.x,
        y = maintbl.y,
        width = maintbl.width,
        height = maintbl.height,
        text = maintbl.text,
        textColor = maintbl.textColor,
        color = maintbl.color
    }
end

function combtAPI.drawButton(buttonName)
    expect(1, buttonName, "string")
    if combtTBL[buttonName] == nil then 
        error("Button not found")
    end
    local button = combtTBL[buttonName]
    local textColorC = button.textColor
    local colorC = button.color
    button.textColor = button.textColor or "0"
    button.color = button.color or "d"
    if type(button.textColor) == "number" then
        button.textColor = color_hex_lookup[button.textColor]
    end
    if type(button.color) == "number" then
        button.color = color_hex_lookup[button.color]
    end
    button.text = button.text or ""
    for i=button.y,button.y+button.height-1 do
        term.setCursorPos(button.x,i)
        term.blit(string.rep(" ",button.width),button.textColor:rep(button.width),button.color:rep(button.width))
    end
    combtAPI.writeCentered(button.x,button.y,button.width,button.height,button.text,colorC,textColorC)
end

function combtAPI.modifyButton(maintbl)
    expect(1, maintbl, "table")
    expect(2, maintbl.x, "number", "nil")
    expect(3, maintbl.y, "number", "nil")
    expect(4, maintbl.width, "number", "nil")
    expect(5, maintbl.height, "number", "nil")
    expect(6, maintbl.text, "string", "nil")
    expect(7, maintbl.textColor, "string", "number", "nil")
    expect(8, maintbl.color, "string", "number", "nil")
    expect(9, maintbl.buttonName, "string")
    combtTBL = combtTBL or {}
    if combtTBL[maintbl.buttonName] == nil then 
        error("Button not found")
    end
    maintbl.x = maintbl.x or combtTBL[maintbl.buttonName].x
    maintbl.y = maintbl.y or combtTBL[maintbl.buttonName].y
    maintbl.width = maintbl.width or combtTBL[maintbl.buttonName].width
    maintbl.height = maintbl.height or combtTBL[maintbl.buttonName].height
    maintbl.text = maintbl.text or combtTBL[maintbl.buttonName].text
    maintbl.textColor = maintbl.textColor or combtTBL[maintbl.buttonName].textColor
    maintbl.color = maintbl.color or combtTBL[maintbl.buttonName].color
    if type(maintbl.textColor) == "number" then
        maintbl.textColor = color_hex_lookup[maintbl.textColor]
    end
    if type(maintbl.color) == "number" then
        maintbl.color = color_hex_lookup[maintbl.color]
    end
    combtTBL[maintbl.buttonName].x = maintbl.x
    combtTBL[maintbl.buttonName].y = maintbl.y
    combtTBL[maintbl.buttonName].width = maintbl.width
    combtTBL[maintbl.buttonName].height = maintbl.height
    combtTBL[maintbl.buttonName].text = maintbl.text
    combtTBL[maintbl.buttonName].textColor = maintbl.textColor
    combtTBL[maintbl.buttonName].color = maintbl.color
    combtAPI.drawButton(maintbl.buttonName)
end

function combtAPI.check(buttonName,mx,my)
    expect(1,buttonName,"string")
    expect(2,mx,"number")
    expect(3,my,"number")
    local maintbl = combtTBL[buttonName]
    if combtAPI.mbIsWithin(mx, my, maintbl.x, maintbl.y, maintbl.width, maintbl.height) then
        return true
    else
        return false
    end
end

return combtAPI