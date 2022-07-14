local api = require("combtAPI2")
local canvas = api.create()
canvas:make({
    x=2,y=2,width=4,height=3,
    color=colors.green,textColor=colors.red,
    text="hi", name="hiButton", on_click=function()
        print("hiButton1")
        sleep(3)
        print("hiButton2")
    end
})
canvas:draw("hiButton")
canvas:make({
    x=6,y=2,width=5,height=3,
    color=colors.green,textColor=colors.red,
    text="hoi", name="hoiButton", on_click=function()
        print("hoiButton1")
        sleep(5)
        print("hoiButton2")
    end
})
canvas:draw("hoiButton")
canvas:execute()
