local drawutils = require 'src.drawutils'

local Minion = {}

function Minion.new(hp, pos)
    local minion = {
        hp = hp or 300,
        maxhp = 300,
        pos = pos or {x = 200, y = 400},
        size = 15,
        color = {r = 1, g = 1, b = 0},
        defaultColor = {r = 1, g = 1, b = 0},
        update = function(self, dt, index)
            if self.hp <= 0 then
                -- die
                table.remove(gs.npcs, index)
            end
        end,
        draw = function(self)
            love.graphics.setColor(self.color.r, self.color.g, self.color.b)
            love.graphics.circle("fill", self.pos.x, self.pos.y, self.size)

            drawutils.drawHealthbar(self.pos, self.size, self.hp, self.maxhp)
        end,
    }
    return minion
end

return Minion
