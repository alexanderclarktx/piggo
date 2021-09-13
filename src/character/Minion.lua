local drawutils = require 'src.util.drawutils'
local ICharacter = require 'src.character.ICharacter'

local Minion = {}

local update, draw

local image = love.graphics.newArrayImage({
    "res/piggo/piggo1.png",
    "res/piggo/piggo2.png",
    "res/piggo/piggo3.png",
})

function Minion.new(x, y, hp)
    assert(hp > 0, x >= 0, y >= 0)

    local minion = ICharacter.new(
        update, draw,
        x, y, hp, 300, 300, 15,
        {}
    )
    minion.frame = 1
    minion.frameLast = 0
    minion.framecd = 0.13
    image:setFilter("nearest", "nearest")

    return minion
end

function update(self, dt, index)
    -- pick random place to move to
    if self.meta.marker == nil then
        self.meta.marker = {
            x = math.random() * love.graphics.getWidth(),
            y = math.random() * love.graphics.getHeight()
        }
    end

    -- update animation frame
    if self.dt - self.frameLast > self.framecd then
        self.frameLast = self.dt
        self.frame = (self.frame + 1) % 3 + 1
    end
end

function draw(self)
    love.graphics.setColor(1, 0.7, 0)
    love.graphics.drawLayer(
        image, self.frame,
        self.body:getX(), self.body:getY(),
        0, 3 * self.facingRight, 3, 7, 7
    )
end

return Minion
