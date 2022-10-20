local Name = {}

local Component = require "ecstacy.Component"

function Name.new(name)
    assert(name)
    return Component.new("name", name)
end

return Name
