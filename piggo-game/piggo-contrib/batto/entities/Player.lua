local Player = {}

local Entity = require "piggo-core.ecs.Entity"
-- local Name = require "piggo-contrib.ecs.batto.components.Name"
-- local Health = require "piggo-contrib.ecs.batto.components.Health"

function Player.new(name, health)
    local player = {
        -- name = Name.new(name),
        -- health = Health.new(health),
    }
    return Entity.new("player", player)
end

return Player
