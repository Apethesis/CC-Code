
local function update(link, ver)
    local req, err = http.request(link)
    assert(req, err)

    local txt = req.readAll()
    local GHVer = tonumber(txt:match("%d%.%d$"))
    if GHVer > ver then
        local f = fs.open(shell.getRunningProgram(), "w")
        f.write(txt)
    end
end

return update