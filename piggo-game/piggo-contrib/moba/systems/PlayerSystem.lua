local PlayerSystem = {}

local Health = require "piggo-core.ecs.components.Health"
local Name = require "piggo-core.ecs.components.Name"
local Position = require "piggo-core.ecs.components.Position"
local Size = require "piggo-core.ecs.components.Size"
local Spell = require "piggo-core.ecs.components.Spell"
local Velocity = require "piggo-core.ecs.components.Velocity"

local update, draw

local update, draw, addPlayer

function PlayerSystem.new(root)
    local playerSystem = {
        root = root,
        update = update, draw = draw,
        addPlayer = addPlayer
    }

    return playerSystem
end

function addPlayer(self, name)
    self.root.addEntity({
        name = Name.new(name),
        position = Position.new(100, 100),
        velocity = Velocity.new(),
        size = Size.new(),
        health = Health.new(100),
        spell = Spell.new("teleport")
    })
end

function update(self, dt)

end

function draw(self)

end

return PlayerSystem
