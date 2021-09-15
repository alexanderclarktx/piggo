local drawutils = require 'src.util.drawutils'
local ICharacter = require 'src.character.ICharacter'

local Minion = {}

local update, draw

local image = love.graphics.newArrayImage({
    "res/piggo/piggo1.png",
    "res/piggo/piggo2.png",
    "res/piggo/piggo3.png",
})
image:setFilter("nearest", "nearest")

function Minion.new(x, y, hp, marker)
    assert(type(x) == "number")
    assert(type(y) == "number")
    assert(type(hp) == "number")
    assert(marker.x and marker.y)

    local minion = ICharacter.new(
        update, draw,
        x, y, hp, 300, 300, 15,
        {}
    )
    minion.frame = 1
    minion.frameLast = 0
    minion.framecd = 0.13
    minion.defaultMarker = marker
    minion.color = {r = math.random(), g = math.random(), b = math.random()}

    return minion
end

function update(self, dt, index)
    -- check surroundings for things to attack (minions, champions, structures)

    -- if nothing nearby, move on toward defaultMarker
    if self.meta.marker == nil then
        self.meta.marker = self.defaultMarker
    end

    -- update animation frame
    if self.dt - self.frameLast > self.framecd then
        self.frameLast = self.dt
        self.frame = (self.frame + 1) % 3 + 1
    end
end

function draw(self)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.drawLayer(
        image, self.frame,
        self.body:getX(), self.body:getY(),
        0, 3 * self.facingRight, 3, 8, 7
    )
end

return Minion
