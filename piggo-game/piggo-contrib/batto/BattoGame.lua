local BattoGame = {}

local EcstacyGame = require "ecstacy.EcstacyGame"
local Player = require "piggo-contrib.batto.entities.Player"

local load

function BattoGame.new()
    return EcstacyGame.new(load)
end

function load(self)
    self:addEntity(Player.new(
        "ketomojito", 100
    ))
    -- self:addSystem(CharacterRenderer.))
end

return BattoGame
