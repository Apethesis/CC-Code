local cimg2 = require("cimg2")
local img = cimg2.load("/test.cimg2",1)
img:setPixel(1,1," ",colors.red,colors.blue)
img:setPixel(3,3," ",colors.blue,colors.red)
img:close()