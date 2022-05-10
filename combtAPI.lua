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

---@param x number x coordinate of the click
---@param y number y coordinate of the click
---@param start_x number start x
---@param start_y number start y
---@param width number width
---@param height number height
function combtAPI.mbIsWithin(x,y,start_x,start_y,width,height)
    return x >= start_x and x < start_x+width and y >= start_y and y < start_y+height
end

---@description You are not going to use this, so I wont even docstring it.
function combtAPI.writeCentered(x,y,w,h,text,bg,fg)
    term.setCursorPos(math.ceil(w/2-#text/2+x),math.ceil(h/2)+y-1)
    term.blit(text,fg:rep(#text),bg:rep(#text))
end

---@param maintbl table the main table
function combtAPI.makeButton(maintbl)
    expect(1, maintbl, "table")
    expect(2, maintbl.x, "number")
    expect(3, maintbl.y, "number")
    expect(4, maintbl.width, "number")
    expect(5, maintbl.height, "number")
    expect(6, maintbl.text, "string", "nil")
    expect(7, maintbl.textColor, "string", "number", "nil")
    expect(8, maintbl.color, "string", "number", "nil")
    expect(8, maintbl.visible, "boolean", "nil")
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
        color = maintbl.color,
        visible = maintbl.visible
    }
end

---@param buttonName string the button name
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
    if button.visible == false then
        textColorC = color_hex_lookup[term.getTextColor()]
        colorC = color_hex_lookup[term.getBackgroundColor()]
    end
    button.text = button.text or ""
    for i=button.y,button.y+button.height-1 do
        term.setCursorPos(button.x,i)
        term.blit(string.rep(" ",button.width),textColorC:rep(button.width),colorC:rep(button.width))
    end
    if button.visible == true then
        combtAPI.writeCentered(button.x,button.y,button.width,button.height,button.text,colorC,textColorC)
    end
end

---@param maintbl table
function combtAPI.modifyButton(maintbl)
    expect(1, maintbl, "table")
    expect(2, maintbl.x, "number", "nil")
    expect(3, maintbl.y, "number", "nil")
    expect(4, maintbl.width, "number", "nil")
    expect(5, maintbl.height, "number", "nil")
    expect(6, maintbl.text, "string", "nil")
    expect(7, maintbl.textColor, "string", "number", "nil")
    expect(8, maintbl.color, "string", "number", "nil")
    expect(9, maintbl.visible, "boolean", "nil")
    expect(10, maintbl.buttonName, "string")
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
    maintbl.visible = maintbl.visible or combtTBL[maintbl.buttonName].visible
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
    combtTBL[maintbl.buttonName].visible = maintbl.visible
    combtAPI.drawButton(maintbl.buttonName)
end

---@param buttonName string
---@param mx number
---@param my number
function combtAPI.check(buttonName,mx,my)
    expect(1,buttonName,"string")
    expect(2,mx,"number")
    expect(3,my,"number")
    local maintbl = combtTBL[buttonName]
    if maintbl.visible == false then
        return false
    end
    if combtAPI.mbIsWithin(mx, my, maintbl.x, maintbl.y, maintbl.width, maintbl.height) then
        return true
    else
        return false
    end
end

function combtAPI.removeButton(buttonName)
    expect(1,buttonName,"string")
    combtTBL[buttonName] = nil
end

return combtAPI
