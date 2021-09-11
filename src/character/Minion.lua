local drawutils = require 'src.util.drawutils'
local ICharacter = require 'src.character.ICharacter'

local Minion = {}

local update, draw

local color = {r = 1, g = 1, b = 0}

function Minion.new(hp, pos)
    assert(hp, hp > 0, pos, pos.x, pos.y)
    return ICharacter.new(
        update, draw,
        pos, hp, 300, 300, 15,
        {}
    )
end

function update(self, dt, index)
    if self.meta.marker == nil then
        self.meta.marker = {
            x = math.random() * love.graphics.getWidth(),
            y = math.random() * love.graphics.getHeight()
        }
    end
end

function draw(self)
    love.graphics.setColor(color.r, color.g, color.b)
    love.graphics.circle("fill", self.meta.pos.x, self.meta.pos.y, self.meta.size)
    drawutils.drawHealthbar(self.meta.pos, self.meta.size, self.meta.hp, self.meta.maxhp)
end

return Minion
