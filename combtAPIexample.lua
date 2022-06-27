local api = require("combtAPI2")
local canvas = api.create()
canvas:make({
    x=2,y=2,width=4,height=3,
    color=colors.green,textColor=colors.red,
    text="hi", name="hiButton", on_click=function()
        error("it works",0)
    end
})
canvas:draw("hiButton")
local function hello()
    while true do
        print("hello worldie")
        canvas:draw("hiButton")
        sleep(3)
    end
end
canvas:execute(hello)
