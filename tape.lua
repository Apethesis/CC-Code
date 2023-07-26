local args = {...}
local tapefile = fs.open(args[1],"rb")
local tapedrive = peripheral.find("tape_drive")
local read = tapefile.read()
do
    if read == nil then
        return
    end
    read = tostring(read)
    tapedrive.write(read)
    read = tapefile.read()
end
