local Ecstacy = {}

local Entity = require "piggo-core.ecs.Entity"

local update, draw, addSystem, addEntity

function Ecstacy.new()
    local ecstacy = {
        entities = {},
        systems = {},
        update = update, draw = draw,
        addSystem = addSystem, addEntity = addEntity
    }
    return ecstacy
end

function addSystem(self, system)
    table.insert(self.systems, system)
end

function addEntity(self, entity)
    log:debug("adding entity", Entity.debug(entity))
    table.insert(self.entities, entity)
end

function update(self, dt)
    for _, system in ipairs(self.systems) do
        -- System.debug(system)
        -- system:update(self.entities)
    end
    for _, entity in ipairs(self.entities) do
        -- Entity.debug(entity)
    end
end

function draw(self)
    for _, system in ipairs(self.systems) do
        print("drawing ", system.name)
        -- system:draw(self.entities)
    end
end

return Ecstacy
