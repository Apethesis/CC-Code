local img = require("cimg2").load("/test.cimg2",0)
print(textutils.serialize(img:readPixel(1,1)))
print(textutils.serialize(img:readPixel(3,3)))
