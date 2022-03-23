local ver = 1.2
local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/compaint.lua")
local version = request.readLine()
request.close()
local versionNumber = version:match("= (.+)")
if not ver == versionNumber then
    fs.delete("./compaint.lua")
    fs.delete("./comlib.lua")
    local request = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/compaint.lua")
    local newver = fs.open("./compaint.lua","w")
    newver.write(request.readAll())
    request.close()
    newver.close()
    error("ComPaint updated.")
end
print("This program is still in beta, and isn't stable.")
print("Do you wish to continue? (yes/no)")
local beta = read()
if beta == "no" then
    os.queueEvent("terminate")
end
if not fs.exists("./comlib.lua") then
    local htg = http.get("https://raw.githubusercontent.com/Apethesis/CC-Code/main/comlib.lua")
    local htf = fs.open("./comlib.lua","w")
    local x,y = term.getSize()
    local ax = x - 17
    htf.write(htg.readAll())
    htf.close()
    term.setCursorPos(ax,y)
    term.setTextColor(colors.white)
    term.setBackgroundColor(colors.black)
    term.write("comlib downloaded")
    print(" ")
    term.setCursorPos(1,y)
    htg.close()
end
local comlib = require("comlib")

term.clear()
local colr = colors.white
local btable = {
    [1] = colors.white,
    [2] = colors.orange,
    [3] = colors.magenta,
    [4] = colors.lightBlue,
    [5] = colors.yellow,
    [6] = colors.lime,
    [7] = colors.pink,
    [8] = colors.gray,
    [9] = colors.lightGray,
    [10] = colors.cyan,
    [11] = colors.purple,
    [12] = colors.blue,
    [13] = colors.brown,
    [14] = colors.green,
    [15] = colors.red,
    [16] = colors.black
}
for i = 1,16 do
    comlib.prite(i,1," ",colors.white,btable[i])
end
function clrbutton()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        if btable[x] and y == 1 then
            colr = btable[x]
        end
        local x,y = term.getSize()
        local ax = x - 17
        comlib.prite(ax,y,"Changed color to "..colr)
    end
end
function draw()
    while true do
        local event, button, x, y = os.pullEvent("mouse_click")
        local eventType, _, _, _, _ = os.pullEvent()
        if y > 1 then
            comlib.prite(x,y," ",colors.white,btable[colr])
            local ex,ey = term.getSize()
            local ax = ex - 17
            comlib.prite(ax,ey,"Drew at x"..x.." y"..y.."        ")
            while eventType == "mouse_drag" do
                local deve, dbut, dx, dy = os.pullEvent("mouse_drag")
                comlib.prite(dx,dy," ",colors.white,btable[colr])
                comlib.prite(ax,ey,"Drew at x"..x.." y"..y.."        ")
                sleep()
            end
        end
    end
end
function sbug()
    while true do
        local x,y = term.getSize()
        local ay = y - 1
        comlib.prite(x,ay,colr)
        sleep(0.1)
    end
end
function termcheck()
    while true do
        os.pullEventRaw("terminate") -- terminate can only be pulled via Raw
        term.clear()
        term.setCursorPos(1,1)
        error("",0) -- to make the program exit we throw an invisible error
    end
end
local tx,ty = term.getSize()
comlib.prite(tx-12,1,"ComPaint v"..versionNumber)
while true do
    parallel.waitForAny(clrbutton,draw,sbug,termcheck)
    sleep(0.1)
end
