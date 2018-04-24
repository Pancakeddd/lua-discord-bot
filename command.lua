local pprint = require "pprint"
require "sertable"
require "util"

local commands = {}

local prefix = ""

function setPrefix(str)
    prefix = str
end

function sendErrorArg(msg)
    msg.channel:send("Unexpected amount of arguments")
end

function addCommand(name,func)
    if commands[prefix .. name] then return end
    commands[prefix .. name] = func
end

function runCommand(name,...)
    if not commands[name] then return false end
    commands[name](...)
end

function getPrefix()
    return prefix
end

function addCommands()

    addCommand("help",function(msg)
        local str = "Commands.\n"
        for k,v in pairs(commands) do
            str = str .. "\t\t" .. k .. "\n"
        end
        msg.channel:send(str)
    end)

    addCommand("info",function(msg,_,_,j)
        local fil = {}
        for k,v in pairs(j["info"]) do
            local t = {}
            t.name = k
            t.value = v
            t.inline = true
            table.insert(fil,t)
        end
        msg.channel:send({
                embed = {
                    title = "Info",
                    fields = fil
                }
            })
    end)

    addCommand("echo",function(msg,args)
        if args[2] then
            msg.channel:send(args[2])
        else
            sendErrorArg(msg)
        end
    end)
    
    addCommand("whatis",function(msg,args)
        local data,err = table.load("defs.data")
        if err ~= nil then return end
        if args[2] then
            if data[args[2]] then
                msg.channel:send(data[args[2]])
            else
                msg.channel:send("Unknown data item")
            end
        else
            sendErrorArg(msg)
        end
    end)

    addCommand("def",function(msg,args)
        local data,err = table.load("defs.data")
        if err ~= nil then return end
        if args[3] then
            if data[args[2]] then
                msg.channel:send("This has already been defined")
            else
                data[args[2]] = utilGetAfter(3,args)
                msg.channel:send(args[2].." has been added successfully")
            end
        else
            sendErrorArg(msg)
        end
        table.save(data,"defs.data")
    end)

end