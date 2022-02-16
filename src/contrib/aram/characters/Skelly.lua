local Skelly = {}

local ICharacter = require "src.piggo.core.ICharacter"

local SkellyAxe = require "src.contrib.aram.abilities.SkellyAxe"
local SkellyShield = require "src.contrib.aram.abilities.SkellyShield"
local SkellyPush = require "src.contrib.aram.abilities.SkellyPush"
local SkellyUlti = require "src.contrib.aram.abilities.SkellyUlti"

local update, draw

function Skelly.new(world, x, y, hp)
    assert(hp > 0 and x >= 0 and y >= 0)

    local skelly = ICharacter.new(
        world,
        update, draw,
        x, y, hp, 1000, 400, 20,
        {
            q = SkellyAxe.new(),
            w = SkellyShield.new(),
            e = SkellyPush.new(),
            r = SkellyUlti.new(),
        }
    )

    skelly.frame = 1
    skelly.frameLast = 0
    skelly.framecd = 13

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
