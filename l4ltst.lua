local log = require("log4l")
local curlog = log.create()
curlog:log("Log4L started, welcome :)","test")
curlog:log("This is a warn","test",1)
curlog:log("This is an error","test",2)
curlog:log("And this... is true power (jk)","test",3)
curlog:log("This is a debug message","test",4)
curlog:stop()