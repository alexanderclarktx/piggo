local Inventory = {}
local Weapon = require "piggo-core.Weapon"

local draw

function Inventory.new() 
    local inventory = {
        state = {
            items = {
                Weapon.new(true, 200, 20)
            }
        },
        draw = draw
    }
    return inventory
end

function draw(self, charX, charY)
    love.graphics.rectangle("line", charX, charY, 500, 50)
end

return Inventory
