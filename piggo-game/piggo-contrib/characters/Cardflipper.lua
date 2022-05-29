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
            v = Rush.new()
        }
    )

    cardflipper.state.animationFrame = 1
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

    -- update direction
    if right > 0 then
        self.state.facingRight = 1
    elseif right < 0 then
        self.state.facingRight = -1
    end

    -- check if character is moving
    if up ~= 0 or right ~= 0 then
        self.state.moving = true
    else
        self.state.moving = false 
    end

    -- update animation frame
    if self.state.moving then
        if self.state.frame % 8 == 0 then
            self.state.animationFrame = (self.state.animationFrame + 1) % 3 + 1    
        end
    else
        self.state.animationFrame = 1
    end

    -- move character
    self.state.body:setPosition(
        self.state.body:getX() + rightSpeed,
        self.state.body:getY() + upSpeed
    )
end

function draw(self)
    -- draw skelly
    assert(self.state.color)
    love.graphics.setColor(self.state.color)
    love.graphics.draw(
        self.image[self.state.animationFrame],
        self.state.body:getX(), self.state.body:getY(),
        0, 4 * self.state.facingRight, 4, 6, 6
    )
end

return Cardflipper
