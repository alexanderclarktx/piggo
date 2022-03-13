local Skelly = {}

local ICharacter = require "piggo-core.ICharacter"

local Zap = require "piggo-contrib.abilities.Zap"
local Shield = require "piggo-contrib.abilities.Shield"
local Blink = require "piggo-contrib.abilities.Blink"
local Rush = require "piggo-contrib.abilities.Rush"

local update, draw

function Skelly.new(world, x, y, hp)
    assert(hp > 0 and type(x) == "number" and type(y) == "number")

    local skelly = ICharacter.new(
        world,
        update, draw,
        x, y, hp, 1000, 350, 20,
        {
            q = Zap.new(),
            w = Shield.new(),
            e = Blink.new(),
            r = Rush.new(),
        }
    )

    skelly.frame = 1
    skelly.frameLast = 0
    skelly.framecd = 13
    skelly.animationFrame = 1

    return skelly
end

function update(self)
    -- update animation frame
    if self.state.frame - self.frameLast > self.framecd then
        self.frameLast = self.state.frame
        self.animationFrame = (self.state.frame + 1) % 3 + 1
    end
end

function draw(self)
    if self.image == nil then
        self.image = love.graphics.newArrayImage({
            "res/skelly/skelly1.png",
            "res/skelly/skelly2.png",
            "res/skelly/skelly3.png",
        })
        self.image:setFilter("nearest", "nearest")
    end

    -- pick animation frame
    local frameToDraw = self.animationFrame
    local velocity = {self.state.body:getLinearVelocity()}
    if 0 == velocity[1] and 0 == velocity[2] then
        frameToDraw = 1
    end

    -- draw skelly
    assert(self.state.color)
    love.graphics.setColor(self.state.color)
    love.graphics.drawLayer(
        self.image, frameToDraw,
        self.state.body:getX(), self.state.body:getY(),
        0, 4 * self.state.facingRight, 4, 6, 6
    )
end

return Skelly
