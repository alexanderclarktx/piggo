local drawutils = require 'src.drawutils'

local Minion = {}

function Minion.new(hp, pos)
    local minion = {
        hp = hp or 300,
        maxhp = 300,
        pos = pos or {x = 200, y = 400},
        draw = function(self)
            love.graphics.setColor(1, 1, 0)
            love.graphics.circle("fill", self.pos.x, self.pos.y, 5)

            drawutils.drawHealthbar(self.pos, self.hp, self.maxhp)
        end,
    }
    return minion
end

return Minion
