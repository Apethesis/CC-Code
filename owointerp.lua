local function create_memory()
    local proxy = {}
    local mem = setmetatable({},{
        __index=function(self,key)
            if not rawget(proxy,key) then
                rawset(proxy,key,0)
                return 0
            else
                return rawget(proxy,key)
            end
        end,
        __newindex=function(self,key,value)
            if value > 255 then value = 0 end
            if value < 0 then value = 255 end
            rawset(proxy,key,value)
            rawset(self,key,nil)
        end
    })
    return mem
end

local function precise_sleep(t)
    local ftime = os.epoch("utc")+t*1000
    while os.epoch("utc") < ftime do
        os.queueEvent("waiting")
        os.pullEvent()
    end
end

local argsSeparator = 255 -- Peripheral arguments separator

local function interpret(program,interpret_speed)
    local memory = create_memory()
    local stack = {}
    local active_loop = false
    local loops = 0
    local cursor = 0
    local bf_ops = program:gsub("[^%!%OwO%°w°%UwU%QwQ%@w@%>w<%~w~%¯w¯p]","")
    local i=1
    local pted = false
    local ign_newline = false
    while i<=#bf_ops do
        local op = bf_ops:sub(i,i)
        local process_arg = true
        if active_loop then
            if op == "~w~" then loops = loops + 1 end
            if op == "¯w¯" then
                if loops == 0 then active_loop = false
                else loops = loops - 1 end
            end
            process_arg = false
        end
        if process_arg then
            if op == "UwU" then
                memory[cursor] = memory[cursor] + 1
            elseif op == "QwQ" then
                memory[cursor] = memory[cursor] - 1
            elseif op == "OwO" then
                if memory[cursor+1] then cursor = cursor + 1 end
            elseif op == "°w°" then
                if memory[cursor-1] then cursor = cursor - 1 end
            elseif op == "@w@" then
                if (memory[cursor] == 0x0A) and (not ign_newline) then print()
                else
                    term.write(string.char(math.max(0,math.min(255,memory[cursor]))))
                    if ign_newline and memory[cursor] == 0x0A then ign_newline = false end
                end
                pted = true
            elseif op == ">w<" then
                local inp = select(2,os.pullEvent("char")):sub(1,1) or ""
                term.write(inp)
                local byte = inp:byte()
                if byte then memory[cursor] = byte end
            elseif op == "~w~" then
                if memory[cursor] == 0 then active_loop = true
                else table.insert(stack,i) end
            elseif op == "¯w¯" then
                if memory[cursor] > 0 then i = stack[#stack]
                else table.remove(stack,#stack)
                end
            elseif op == "!" then
                ign_newline = true
            elseif op == "p" then
                local peripheralName = {}
                while true do -- If we dont hit an end or a separator we read the memory
                    if memory[cursor] == argsSeparator then break end
                    if memory[cursor] == 0 then
                        error("Hit 0 too early at "..cursor) -- Change this or use whatever you use to error
                    end
                    table.insert(peripheralName, string.char(memory[cursor])) -- Just assume everything we get a string
                    -- This will probably backfire later.
                    cursor = cursor + 1
                end
                peripheralName = table.concat(peripheralName, "")
                local peripheralArgs = {}
                local argCount = 0
                local offset = 0
                while true do -- Count all the arguments
                    local currentCell = memory[cursor+offset]
                    if currentCell == 0 then break end
                    if currentCell == argsSeparator then argCount = argCount + 1 end
                    if currentCell ~= argsSeparator then
                        peripheralArgs[argCount] = peripheralArgs[argCount] or {}
                        if bit32.band(currentCell, 0x60) == 0 then
                            table.insert(peripheralArgs[argCount], currentCell-bit32.band(currentCell, 0x60))
                        else
                            table.insert(peripheralArgs[argCount], string.char(currentCell))
                        end
                    end
                    offset = offset + 1
                end
                if argCount == 0 then
                    error("No arguments for peripheral call")
                end
                for i=1, #peripheralArgs do
                    local isNumber = false
                    if tonumber(peripheralArgs[i]) then
                        isNumber = true
                    end
                    peripheralArgs[i] = table.concat(peripheralArgs[i], "")
                    if isNumber then peripheralArgs[i] = tonumber(peripheralArgs[i]) end
                end
                peripheral.call(peripheralName, table.unpack(peripheralArgs))
            end
        end
        if not interpret_speed or interpret_speed < 0.00001 then
            os.queueEvent("wait")
            os.pullEvent()
        else precise_sleep(interpret_speed) end
        i = i + 1
    end
    return memory,pted
end

local function main(...)
    local args = {...}
    local path = shell.resolve(args[1] or "")
    if not args[1] or args[1] == "" then
        local history = {}
        local program = ""
        term.setTextColor(colors.yellow)
        print("Enter 'run' when you are finished with your program or 'exit' to exit.")
        term.setTextColor(colors.white)
        while true do
            term.blit("> ","E0","FF")
            local inp = read(nil,history)
            table.insert(history,inp)
            inp = inp:gsub("rep%(.-,.-%)",function(data)
                local cnt,str = data:match("rep%((.-),(.-)%)")
                return string.rep(str,tonumber(cnt))
            end)
            if inp == "run" then break
            elseif inp == "exit" then return
            else program = program .. inp end
        end
        local mem,pted = interpret(program,tonumber(args[2] or ""))
        if pted then print() end
    elseif args[1] == "-i" then
        local program = args[2] or ""
        local mem,pted = interpret(program,tonumber(args[3] or ""))
        if pted then print() end
    elseif args[1] == "-sh" then
        local history = {}
        term.setTextColor(colors.yellow)
        print("Bwainfuck (UwU) pwompt.")
        print("Run 'exit' to exit.")
        term.setTextColor(colors.white)
        while true do
            term.blit("BF> ","00E0","FFFF")
            local inp = read(nil,history)
            table.insert(history,inp)
            if inp == "exit" then break end
            local mem,pted = interpret(inp,tonumber(args[2] or ""))
            if pted then print() end
        end
    else
        if fs.exists(path) and path:match("%.bf$") then
            local file = fs.open(path,"r")
            local data = file.readAll()
            file.close()
            interpret(data,tonumber(args[2] or ""))
        else
            error("Path doesnt exist or doesnt have the .bf extension: "..path,0)
        end
    end
end

main(...)
