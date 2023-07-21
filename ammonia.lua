local oldPull = os.pullEvent
os.pullEvent = os.pullEventRaw
term.clear()
if not fs.exists("./sha256.lua") then
    local sha = http.get("https://pastebin.com/raw/6UV4qfNF")
    if sha == nil then
        error("Failed to download sha256.lua",0)
    end
    local shaFile = fs.open("./sha256.lua","w")
    shaFile.write(sha.readAll())
    shaFile.close()
    sha.close()
end
local sha256 = require("sha256")
local lockName = "Ammonia" -- Feel free to rename this if you'd like, just don't make it too long.
local tx,ty = term.getSize()
term.setCursorPos(tx-string.len(lockName),1)
term.setTextColor(colors.gray) -- If you want the text to not be visible, make it colors.black.
term.write(lockName)
term.setTextColor(colors.white)
if not fs.exists("/.amcreds") then
    term.setCursorPos(1,1)
    term.write("Please insert your password")
    print()
    local pass = read("\007")
    print("Please repeat your password.")
    local pass2 = read("\007")
    while pass2 ~= pass do
        print("Passwords do not match, please try again.")
        pass2 = read("\007")
    end
    local hpass = string.char(unpack(sha256.digest(pass)))
    local creds = fs.open("/.amcreds","w")
    print(textutils.serialize(hpass))
    creds.write(hpass)
    creds.close()
    os.reboot()
elseif fs.exists("/.amcreds") then
    term.setCursorPos(1,1)
    term.write("Welcome, please log in.")
    print()
    local creds = fs.open("/.amcreds","r")
    local hpass = creds.readAll()
    creds.close()
    local pass = read("\007")
    local hpass2 = string.char(unpack(sha256.digest(pass)))
    while hpass2 ~= hpass do
        print("Incorrect password, please try again.")
        pass = read("\007")
        hpass2 = string.char(unpack(sha256.digest(pass)))
    end
end
term.clear()
term.setTextColor(colors.yellow)
term.setCursorPos(1,1)
term.write("CraftOS 1.8")
print()
