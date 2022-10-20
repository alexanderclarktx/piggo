local System = {}

local update, draw

function System.new(name, update, draw)
    local system = {
        name = name,
        update = update,
        draw = draw
    }
    return system
end

function System.debug(system)
    return string.format("{name:%s, hasDraw:%s}", system.name, system.draw ~= null)
end

return System
