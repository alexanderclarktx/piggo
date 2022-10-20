local EcstacyGame = {}

local Entity = require "ecstacy.Entity"
local System = require "ecstacy.System"

local update, draw, addSystem, addEntity

function EcstacyGame.new(load)
    local ecstacyGame = {
        load = load,
        update = update, draw = draw,
        addSystem = addSystem, addEntity = addEntity,
        entities = {},
        systems = {},
    }
    return ecstacyGame
end

function addSystem(self, system)
    log:debug("adding system", System.debug(system))
    table.insert(self.systems, system)
end

function addEntity(self, entity)
    log:debug("adding entity", Entity.debug(entity))
    table.insert(self.entities, entity)
end

function update(self, dt)
    for _, system in ipairs(self.systems) do
        system.update(self.entities)
    end
    for _, entity in ipairs(self.entities) do
    end
end

function draw(self)
    for _, system in ipairs(self.systems) do
        system.draw(self.entities)
    end
end

return EcstacyGame
