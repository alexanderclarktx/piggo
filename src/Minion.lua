local drawutils = require 'src.drawutils'
local ICharacter = require 'src.ICharacter'

local Minion = {}

local update, draw

local color, defaultColor = {r = 1, g = 1, b = 0}, {r = 1, g = 1, b = 0}

function Minion.new(hp, pos)
    assert(hp, hp > 0, pos, pos.x, pos.y)
    return ICharacter.new(
        update, draw,
        pos, hp, 300, 300, 15,
        {}
        -- color =  defaultColor = ,
    )
end

function update(self, dt, index)
    -- movement
end

function draw(self)
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.circle("fill", self.meta.pos.x, self.meta.pos.y, self.meta.size)
    drawutils.drawHealthbar(self.meta.pos, self.meta.size, self.meta.hp, self.meta.maxhp)
end

return Minion
