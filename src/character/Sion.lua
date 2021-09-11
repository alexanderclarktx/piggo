local ICharacter = require 'src.character.ICharacter'
local ShapeUtils = require 'src.util.ShapeUtils'

local Sion = {}

local update, draw, sionQ, sionW, sionE, sionR

function Sion.new(pos, hp)
    assert(pos, hp)

    return ICharacter.new(
        update, draw,
        pos, hp, 1000, 360, 20,
        {
            q = {run = sionQ, cd = 2, dt = 2},
            w = {run = sionW, cd = 4, dt = 4},
            e = {run = sionE, cd = 3, dt = 3},
            r = {run = sionR, cd = 5, dt = 5}
        }
    )
end

function update(self, dt) end

function draw(self)
    -- draw sion
    love.graphics.setColor(0, 1, 0.4)
    love.graphics.circle("fill", self.meta.pos.x, self.meta.pos.y, self.meta.size)
end

function sionQ(me)
    me.abilities.q.dt = 0

    -- calculate axe orientation
    local xdiff = love.mouse.getX() - me.meta.pos.x
    local ydiff = love.mouse.getY() - me.meta.pos.y
    local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
    local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

    table.insert(me.effects, {
        name = "Axe",
        drawable = true,
        duration = 0.5,
        dt = 0,
        hitboxDistance = 200,
        hitboxAngle = math.pi/8,
        hitboxStyle = "line",
        xRatio = xRatio,
        yRatio = yRatio,
        segments = {
            {
                time = 0,
                done = false,
                run = function(self, me)
                    -- me.meta.canMove = false
                    -- me.meta.marker = nil
                end
            },
            {
                time = 0.47,
                done = false,
                run = function(self, me, effect)
                    -- TODO contention here (CC from other effects)
                    -- me.meta.canMove = true
                    effect.hitboxStyle = "fill"

                    -- damage
                    me:submitHurtbox("axe", 140, effect.hitboxPoints)
                end
            }
        },
        draw = function(self, me)
            -- first point is on edge of character
            local p1 = {me.meta.pos.x + me.meta.size * self.xRatio, me.meta.pos.y + me.meta.size * self.yRatio}

            -- outer points of triangle
            local p2 = ShapeUtils.rotate({self.xRatio, self.yRatio}, -self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)
            local p3 = ShapeUtils.rotate({self.xRatio, self.yRatio}, self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)

            -- draw axe triangle
            love.graphics.setColor(1, 0, 1)
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
                        color = {r = 1, g = 0, b = 0, alpha = 0.2},
                        radius = 25,
                        width = 50
                    }
                end
            },
            {
                time = 2,
                done = false,
                run = function(self, me)
                    -- TODO damage
                end
            }
        },
        draw = function(self, me)
            love.graphics.setColor(self.shield.color.r, self.shield.color.g, self.shield.color.b)
            love.graphics.setLineWidth(self.shield.width)
            love.graphics.circle("line", me.meta.pos.x, me.meta.pos.y, me.meta.size + self.shield.radius)
            love.graphics.setLineWidth(1)
        end
    })
end

function sionE(me)

end

function sionR(me)

end

return Sion
