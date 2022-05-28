
local function update(link, ver)
    local req, err = http.get(link)
    assert(req, err)

    local txt = req.readAll()
    local GHVerS = txt:match("%d%.%d")
    print(GHVerS)
    local GHVer = tonumber(GHVerS)
    if GHVer > ver then
        local f = fs.open(shell.getRunningProgram(), "w")
        f.write(txt)
    end
end

return update
