local blacklist = {
    ["minecraft:cobblestone"] = true,
    ["minecraft:stone"] = true,
    ["minecraft:gravel"] = true
}
local function other()
    while true do
        for i=1,16 do
            local detail = turtle.getItemDetail(i)
            if detail and blacklist[detail.name] then
                turtle.select(i)
                turtle.drop()
            end
        end
        sleep()
        if turtle.getFuelLevel() <= 10 then
            print("Out of fuel")
            while true do
                for i=1,16 do
                    turtle.select(i)
                    turtle.refuel()
                end
                if turtle.getFuelLevel() > 10 then
                    print("Refueled.")
                    break
                else
                    print("Please put fuel in the turtles inventory and press a key.")
                    os.pullEvent("key")
                end
            end
        end
    end
end
local function dig()
    while true do
        other()
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
        turtle.turnLeft()
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
        turtle.turnRight()
        turtle.turnRight()
        turtle.forward()
        turtle.forward()
        turtle.dig()
        turtle.forward()
        turtle.digUp()
        turtle.digDown()
        turtle.turnLeft()
        turtle.turnLeft()
        turtle.forward()
        turtle.turnRight()
        sleep()
    end
end
dig()
