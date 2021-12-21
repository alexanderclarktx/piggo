local ICharacter = require 'src.character.ICharacter'
local SionAxe = require 'src.equip.SionAxe'
local SionShield = require 'src.equip.SionShield'
local SionPush = require 'src.equip.SionPush'
local SionUlti = require 'src.equip.SionUlti'

local Sion = {}

local update, draw

local image = love.graphics.newArrayImage({
    "res/skelly/skelly1.png",
    "res/skelly/skelly2.png",
    "res/skelly/skelly3.png",
})

function Sion.new(x, y, hp)
    assert(hp > 0, x >= 0, y >= 0)

    local sionAxe = SionAxe.new()

    local sion = ICharacter.new(
        update, draw,
        x, y, hp, 1000, 400, 20,
        {
            q = SionAxe.new(),
            w = SionShield.new(),
            e = SionPush.new(),
            r = SionUlti.new(),
        }
    )

    sion.frame = 1
    sion.frameLast = 0
    sion.framecd = 0.13
    image:setFilter("nearest", "nearest")

    return sion
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

    -- draw sion
    assert(self.color)
    love.graphics.setColor(self.color[1], self.color[2], self.color[3])
    love.graphics.drawLayer(
        image, frameToDraw,
        self.body:getX(), self.body:getY(),
        0, 4 * self.facingRight, 4, 6, 6
    )
end

return Sion
