local Player = {}

local Entity = require "ecstacy.Entity"
local Name = require "piggo-core.components.Name"

function Player.new(name, health)
    local name = Name.new("bobb")
    return Entity.new("player", {name})
end

return Player
