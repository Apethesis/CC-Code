local args = {...}
local ifl = fs.open("/.dbin/data","r")
local data
if ifl == nil then
    data = { ["agreed"] = false }
else
    data = textutils.unserialize(ifl.readAll())
    ifl.close()
end
if not data["agreed"] then
    print("Please read the TOS before using: https://devbin.dev/tos")
    print("Type in 'agree' to agree to the TOS")
    local inp = read()
    if string.lower(inp) == "agree" then
        local ofl = fs.open("/.dbin/data","w")
        local dat = {}
        dat["agreed"] = true
        ofl.write(textutils.serialise(dat))
        ofl.close()
    end
end
ifl = nil
data = nil
local function hlp()
    print("Usages:")
    print("dbin put <filename>")
    print("dbin get <code> <filename>")
end
if args[1] == "get" and args[2] ~= nil and args[3] ~= nil then
    local res = http.get("https://devbin.dev/raw/"..args[2])
    if type(res) ~= "table" then
        error(res,0)
    end
    if args[3]:match("[^%.]+$") == nil or "" then
        args[3] = args[3]..".lua"
    end
    local re = res.readAll()
    local fi = fs.open(args[3],"w")
    fi.write(re)
    fi.close()
    res.close()
elseif args[1] == "put" and args[2] ~= nil then
    local fi = fs.open("./"..args[2],"r")
    http.post("https://devbin.dev/api/v2/paste",textutils.serialiseJSON({
        ["title"] = "DBin Upload",
        ["syntax"] = "lua",
        ["content"] = fi.readAll(),
        ["exposure"] = 1,
        ["asGuest"] = false
    }),{ ["Authorization"] = "AdJ0-0sdhg3RoatrIPXuQ8a13GZX-5Onx23pDUSHokriLZEp", ["Content-Type"] = "application/json" })
    fi.close()
else
    hlp()
end
