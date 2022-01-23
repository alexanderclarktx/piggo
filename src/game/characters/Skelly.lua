local Skelly = {}
local ICharacter = require "src.game.characters.ICharacter"
local SkellyAxe = require "src.game.abilities.SkellyAxe"
local SkellyShield = require "src.game.abilities.SkellyShield"
local SkellyPush = require "src.game.abilities.SkellyPush"
local SkellyUlti = require "src.game.abilities.SkellyUlti"

local update, draw

local image = love.graphics.newArrayImage({
    "res/skelly/skelly1.png",
    "res/skelly/skelly2.png",
    "res/skelly/skelly3.png",
})

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
    skelly.framecd = 0.13
    image:setFilter("nearest", "nearest")

    return skelly
end

function update(self, dt)
    -- update animation frame
    if self.dt - self.frameLast > self.framecd then
        self.frameLast = self.dt
        self.frame = (self.frame + 1) % 3 + 1
    end
end

function draw(self)
    -- pick animation frame
    local frameToDraw = self.frame
    local velocity = {self.body:getLinearVelocity()}
    if 0 == velocity[1] and 0 == velocity[2] then
        frameToDraw = 1
    end

    -- draw skelly
    assert(self.color)
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.drawLayer(
        image, frameToDraw,
        self.body:getX(), self.body:getY(),
        0, 4 * self.facingRight, 4, 6, 6
    )
end

return Skelly
