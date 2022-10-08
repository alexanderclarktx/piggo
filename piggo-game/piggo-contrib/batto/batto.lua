local Batto = {}

local Ecstacy = require "piggo-core.ecs.Ecstacy"
local Player = require "piggo-contrib.ecs.batto.entities.Player"

local load

function Batto.new()
    local batto = Ecstacy.new()
    batto.load = load
    return batto
end

function load(self)
    self:addEntity(Player.new(
        "ketomojito", 100
    ))
    -- self:addSystem(CharacterRenderer.))
end

return Batto
