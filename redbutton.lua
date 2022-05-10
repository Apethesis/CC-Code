local combtAPI = require("combtAPI")
local isOn = false
term.clear()
combtAPI.makeButton({
    x=2,
    y=2,
    width=5,
    height=3,
    text="top",
    textColor=colors.white,
    color=colors.green,
    buttonName="rButton1"
})
combtAPI.drawButton("rButton1")
while true do
    local _,_,mx,my = os.pullEvent("mouse_click")
    if combtAPI.check("rButton1",mx,my) and isOn == true then
        isOn = false
        combtAPI.modifyButton({
            color=colors.red,
            buttonName="rButton1"
        })
        redstone.setOutput("top",false)
    elseif combtAPI.check("rButton1",mx,my) and isOn == false then
        isOn = true
        combtAPI.modifyButton({
            color=colors.green,
            buttonName="rButton1"
        })
        redstone.setOutput("top",true)
    end
    sleep()
end
