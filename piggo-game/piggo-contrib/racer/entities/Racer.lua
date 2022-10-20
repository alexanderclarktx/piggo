local Racer = {}

local Entity = require "ecstacy.Entity"
local Health = require "piggo-core.components.Health"
local Name = require "piggo-core.components.Name"
local Position = require "piggo-core.components.Position"
local Velocity = require "piggo-core.components.Velocity"

function Racer.new(name)
    local racer = {
        health = Health.new(),
        name = Name.new(name),
        position = Position.new(),
        velocity = Velocity.new()
    }
    return Entity.new("racer", racer)
end

return Racer
