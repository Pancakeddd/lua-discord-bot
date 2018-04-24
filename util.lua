function utilSplit(s)
    local r = {}
    for v in s:gmatch("%S+") do table.insert(r, v) end
    return r
end

function utilGetAfter(l,t)
    local s = ""
    for i = l,#t do
        s = s .. t[i] .. " "
    end
    return s
end

function utilHasAtStart(s,p)
    if string.sub(s,1,#p) == p then
        return true
    end
    return false
end