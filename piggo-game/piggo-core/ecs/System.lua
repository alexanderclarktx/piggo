local System = {}

local update, draw

function System.new(system)
    local system = {
        update = update, draw = draw
    }
    return system
end

return System
