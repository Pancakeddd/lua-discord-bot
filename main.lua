local json = require "json"
local discord = require "discordia"
local client = discord.Client()
require "command"
require "util"

function loadJsonFile(filename)
    local f = assert(io.open(filename, "rb"))
    local str = f:read("*all")
    f:close()
    return json.decode(str)
end

local jsd = loadJsonFile("info.json")

setPrefix(jsd["prefix"])
addCommands()

client:on('ready',function() end)

client:on('messageCreate', function(msg)
    local msgt = utilSplit(msg.content)
    if utilHasAtStart(msg.content,getPrefix()) then
        if runCommand(msgt[1],msg,msgt,discord,jsd) == false then
            msg.channel:send("Unknown command. Try "..getPrefix().."help")
        end
    end
end)

client:run("Bot " .. jsd["token"])