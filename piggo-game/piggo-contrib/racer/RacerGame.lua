local RacerGame = {}

local EcstacyGame = require "ecstacy.EcstacyGame"
local Racer = require "piggo-contrib.racer.entities.Racer"
local RacerSystem = require "piggo-contrib.racer.systems.RacerSystem"

local load

function RacerGame.new()
    return EcstacyGame.new(load)
end

function load(self)
    self:addEntity(
        Racer.new("ketomojito")
    )
    self:addSystem(
        RacerSystem.new()   
    )
end

return RacerGame
