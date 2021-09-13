local ICharacter = require 'src.character.ICharacter'
local ShapeUtils = require 'src.util.ShapeUtils'

local Sion = {}

local update, draw, sionQ, sionW, sionE, sionR

local qColors = {
    {1, 0, 0, debug() and 0.3 or 0.6},
    {1, 1, 0, debug() and 0.3 or 0.6},
    {0, 1, 0, debug() and 0.3 or 0.6},
    {0, 1, 1, debug() and 0.3 or 0.6},
}

local image = love.graphics.newArrayImage({
    "res/skelly/skelly1.png",
    "res/skelly/skelly2.png",
    "res/skelly/skelly3.png",
})

function Sion.new(x, y, hp)
    assert(hp > 0, x >= 0, y >= 0)

    local sion = ICharacter.new(
        update, draw,
        x, y, hp, 1000, 400, 20,
        {
            q = {run = sionQ, cd = 0, dt = 1,
                charges = 4, maxCharges = 4, chargeCd = 1, chargeDt = 0
            },
            w = {run = sionW, cd = 4, dt = 4},
            e = {run = sionE, cd = 3, dt = 3},
            r = {run = sionR, cd = 5, dt = 5}
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
    love.graphics.setColor(0.5, 0.7, 1)
    love.graphics.drawLayer(
        image, frameToDraw,
        self.body:getX(), self.body:getY(),
        0, 4 * self.facingRight, 4, 6, 6
    )
end

function sionQ(self)
    if self.abilities.q.dt <= self.abilities.q.cd then return end
    if self.abilities.q.charges <= 0 then return end
    self.abilities.q.dt = 0
    self.abilities.q.charges = self.abilities.q.charges - 1

    -- calculate axe orientation
    local xdiff = state.camera.mx - self.body:getX()
    local ydiff = state.camera.my - self.body:getY()
    local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
    local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

    table.insert(self.effects, {
        name = "Axe",
        drawable = true,
        color = qColors[math.random(#qColors)],
        duration = 0.5,
        dt = 0,
        hitboxDistance = 200,
        hitboxAngle = math.pi/8,
        hitboxStyle = "line",
        xRatio = xRatio,
        yRatio = yRatio,
        segments = {
            {
                time = 0.45,
                done = false,
                run = function(self, me, effect)
                    effect.hitboxStyle = "fill"

                    -- damage
                    me:submitHurtboxPoly("axe", 100, effect.hitboxPoints)
                end
            }
        },
        draw = function(self, me)
            -- first point is on edge of character
            local p1 = {me.body:getX() + me.meta.size * self.xRatio, me.body:getY() + me.meta.size * self.yRatio}

            -- outer points of triangle
            local p2 = ShapeUtils.rotate({self.xRatio, self.yRatio}, -self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)
            local p3 = ShapeUtils.rotate({self.xRatio, self.yRatio}, self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)

            -- draw axe triangle
            love.graphics.setColor(unpack(self.color))
            love.graphics.polygon(self.hitboxStyle, {
                p1[1], p1[2],
                p2[1], p2[2],
                p3[1], p3[2]
            })

            self.hitboxPoints = {p1[1], p1[2], p2[1], p2[2], p3[1], p3[2]}
        end
    })
end

function sionW(me)
    if me.abilities.w.dt < me.abilities.w.cd then return end

    me.abilities.w.dt = 0
    table.insert(me.effects, {
        name = "Shield",
        drawable = true,
        duration = 3,
        dt = 0,
        shield = {
            color = {r = 0.8, g = 0.8, b = 0.8, alpha = 1},
            radius = 2,
            width = 4
        },
        segments = {
            {
                time = 2.9,
                done = false,
                run = function(self, me, effect)
                    effect.shield = {
                        color = {r = 1, g = 0.2, b = 0.2, alpha = 0.2},
                        radius = 25,
                        width = 50
                    }
                end
            },
            {
                time = 2.95,
                done = false,
                run = function(self, me)
                    me:submitHurtboxCircle("Shield", 140, me.body:getX(), me.body:getY(), 50)
                end
            }
        },
        draw = function(self, me)
            love.graphics.setColor(
                self.shield.color.r,
                self.shield.color.g - self.shield.color.g * self.dt / self.duration,
                self.shield.color.b - self.shield.color.b * self.dt / self.duration
            )
            love.graphics.setLineWidth(self.shield.width)
            love.graphics.circle("line", me.body:getX(), me.body:getY(), me.meta.size + self.shield.radius)
            love.graphics.setLineWidth(1)
        end
    })
end

function sionE(me)

end

function sionR(me)

end

return Sion
