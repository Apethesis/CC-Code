--Commandcracker was here

local function checkFuel()
    if turtle.getFuelLevel() <= 4 then
        print("Out of fuel")
        while true do
            for i=1,16 do
                turtle.select(i)
                turtle.refuel()
            end
            if turtle.getFuelLevel() > 4 then
                print("Refueled.")
                break
            else
                print("Please put fuel in the turtles inventory and press a key.")
                os.pullEvent("key")
            end
        end
    end
end

local blacklist = {
    ["minecraft:cobblestone"] = true,
    ["minecraft:stone"] = true, -- granite, andesite, etc
    ["minecraft:gravel"] = true,
    ["chisel:limestone2"] = true,
    ["chisel:marble2"] = true,
}
local function dropItems()
    for i=1,16 do
        local detail = turtle.getItemDetail(i)
        if detail and blacklist[detail.name] then
            turtle.select(i)
            turtle.drop()
        end
    end
end

local go = {}

function go.forward()
    while not turtle.forward() do
        turtle.dig()
    end
end

for i=1,100 do
    for i=1,16 do
        checkFuel()
        turtle.digUp()
        turtle.digDown()
        go.forward()
        dropItems()
    end
    turtle.turnRight()
    turtle.turnRight()
    turtle.down()
end
