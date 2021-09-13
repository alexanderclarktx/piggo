local drawutils = require 'src.util.drawutils'
local ICharacter = require 'src.character.ICharacter'

local Minion = {}

local update, draw

function Minion.new(x, y, hp)
    assert(hp > 0, x >= 0, y >= 0)

    return ICharacter.new(
        update, draw,
        x, y, hp, 300, 300, 15,
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
    love.graphics.setColor(1, 0.7, 0)
    love.graphics.draw(
        love.graphics.newImage("res/piggo.png", {linear = true}),
        self.body:getX(), self.body:getY(),
        0, 3 * self.facingRight, 3, 7, 7
    )
end

return Minion
