local drawutils = require 'src.util.drawutils'
local ICharacter = require 'src.character.ICharacter'

local Minion = {}

local update, draw

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
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(
        love.graphics.newImage("res/piggo.png", {linear = true}),
        self.meta.pos.x, self.meta.pos.y,
        0, 3 * self.facingRight, 3, 7, 7
    )
    -- love.graphics.circle("fill", self.meta.pos.x, self.meta.pos.y, self.meta.size)
    drawutils.drawHealthbar(self.meta.pos, self.meta.size, self.meta.hp, self.meta.maxhp)
end

return Minion
