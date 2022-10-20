local RacerSystem = {}

local System = require "ecstacy.System"

local update, draw

function RacerSystem.new()
    return System.new("RacerSystem", update, draw)
end

function update(dt)
    --
end

function draw(entities)
    for _, entity in ipairs(entities) do
        if entity.type == "racer" then
            love.graphics.setColor(0, 200, 150)
            love.graphics.circle("line", entity.components.position.x, entity.components.position.y, 10)        
        end
    end
end

return RacerSystem
