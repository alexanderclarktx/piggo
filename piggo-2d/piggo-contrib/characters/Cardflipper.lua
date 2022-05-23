local Cardflipper = {}

local ICharacter = require "piggo-core.ICharacter"

local Zap = require "piggo-contrib.abilities.Zap"
local Shield = require "piggo-contrib.abilities.Shield"
local Blink = require "piggo-contrib.abilities.Blink"
local Rush = require "piggo-contrib.abilities.Rush"

local update, draw, animation

function Cardflipper.new(world, x, y)
    local cardflipper = ICharacter.new(
        world,
        update, draw,
        x, y, 100, 1000, 350, 20,
        {
            z = Blink.new(),
            x = Blink.new(),
            c = Blink.new(),
        }
    )

    cardflipper.frame = 1
    cardflipper.frameLast = 0
    cardflipper.framecd = 13
    cardflipper.animationFrame = 1
    cardflipper.image = {
        love.graphics.newImage("res/skelly/skelly1.png"),
        love.graphics.newImage("res/skelly/skelly2.png"),
        love.graphics.newImage("res/skelly/skelly3.png"),
    }

    return cardflipper
end

function update(self)
    local up, right, upSpeed, rightSpeed = 0, 0, 0, 0
    local speed = 3
    local pythHalf = math.sqrt(speed * speed / 2)

    -- get final movement directions
    if love.keyboard.isDown("w") then
        up = up - 1
    end
    if love.keyboard.isDown("s") then
        up = up + 1
    end
    if love.keyboard.isDown("d") then
        right = right + 1
    end
    if love.keyboard.isDown("a") then
        right = right - 1
    end

    -- set speeds
    if up ~= 0 and right ~= 0 then
        upSpeed = up * pythHalf
        rightSpeed = right * pythHalf
    else
        upSpeed = up * speed
        rightSpeed = right * speed
    end

    -- move character
    self.state.body:setPosition(
        self.state.body:getX() + rightSpeed,
        self.state.body:getY() + upSpeed
    )

    -- update animation frame
    if self.state.frame - self.frameLast > self.framecd then
        self.frameLast = self.state.frame
        self.animationFrame = (self.state.frame + 1) % 3 + 1
    end
end

function draw(self)
    -- pick animation frame
    local frameToDraw = self.animationFrame
    local velocity = {self.state.body:getLinearVelocity()}
    if 0 == velocity[1] and 0 == velocity[2] then
        frameToDraw = 1
    end

    -- draw skelly
    assert(self.state.color)
    love.graphics.setColor(self.state.color)
    love.graphics.draw(
        self.image[frameToDraw],
        self.state.body:getX(), self.state.body:getY(),
        0, 4 * self.state.facingRight, 4, 6, 6
    )

    -- love.graphics.setColor(1, 0, 5)
    -- love.graphics.circle(
    --     "line",
    --     self.state.body:getX(),
    --     self.state.body:getY(),
    --     15
    -- )
end

return Cardflipper
