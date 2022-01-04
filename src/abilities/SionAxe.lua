local IAbility = require 'src.abilities.IAbility'
local ShapeUtils = require 'src.util.ShapeUtils'

local SionAxe = {}

local cast, update, draw

local rgb = {
    {1, 0, 0, debug() and 0.3 or 0.6},
    -- {1, 1, 0, debug() and 0.3 or 0.6},
    -- {0, 1, 0, debug() and 0.3 or 0.6},
    -- {0, 1, 1, debug() and 0.3 or 0.6},
}

-- hold down to charge; release for AoE stun and damage
function SionAxe.new()
    local sionAxe = IAbility.new("Sion Axe", cast, update, draw, 2)

    sionAxe.charges = 4
    sionAxe.maxCharges = 4
    sionAxe.chargeCd = 1
    sionAxe.chargeDt = 0

    return sionAxe
end

function cast(self, character)
    assert(character)
    assert(character.body)

    if self.dt <= self.cd then return end
    if self.charges <= 0 then return end
    -- self.dt = 0
    self.charges = self.charges - 1

    -- calculate axe orientation
    local xdiff = state.camera.mx - character.body:getX()
    local ydiff = state.camera.my - character.body:getY()
    local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
    local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

    table.insert(character.effects, {
        name = "Axe",
        drawable = true,
        color = rgb[math.random(#rgb)],
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
                cast = function(character, me, effect)
                    effect.hitboxStyle = "fill"

                    -- damage
                    me:submitHurtboxPoly("axe", 100, effect.hitboxPoints)
                end
            }
        },
        draw = function(character, me)
            -- first point is on edge of character
            local p1 = {me.body:getX() + me.meta.size * character.xRatio, me.body:getY() + me.meta.size * character.yRatio}

            -- outer points of triangle
            local p2 = ShapeUtils.rotate({character.xRatio, character.yRatio}, -character.hitboxAngle, p1[1], p1[2], character.hitboxDistance)
            local p3 = ShapeUtils.rotate({character.xRatio, character.yRatio}, character.hitboxAngle, p1[1], p1[2], character.hitboxDistance)

            -- draw axe triangle
            love.graphics.setColor(unpack(character.color))
            love.graphics.polygon(character.hitboxStyle, {
                p1[1], p1[2],
                p2[1], p2[2],
                p3[1], p3[2]
            })

            character.hitboxPoints = {p1[1], p1[2], p2[1], p2[2], p3[1], p3[2]}
        end
    })
end

function update(self, dt)

end

function draw(self)

end

-- character q --> myItems[q].cast()
-- character w --> myItems[w].cast()
return SionAxe
