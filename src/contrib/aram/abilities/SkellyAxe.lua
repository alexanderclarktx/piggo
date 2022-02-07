local SkellyAxe = {}
local IAbility = require "src.piggo.core.IAbility"
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local cast, update, draw

-- hold down to charge; release for AoE stun and damage
function SkellyAxe.new()
    local skellyAxe = IAbility.new("Skelly Axe", cast, update, draw, 2)

    skellyAxe.charges = 4
    skellyAxe.maxCharges = 4
    skellyAxe.chargeCd = 1
    skellyAxe.chargeDt = 0

    return skellyAxe
end

function cast(self, character, mouseX, mouseY)
    assert(character and character.body and mouseX and mouseY)

    if self.dt <= self.cd then return end
    if self.charges <= 0 then return end
    -- self.dt = 0
    self.charges = self.charges - 1

    -- calculate axe orientation
    local xdiff = mouseX - character.body:getX()
    local ydiff = mouseY - character.body:getY()
    local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
    local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

    table.insert(character.effects, {
        name = "Axe",
        drawable = true,
        color = {1, 0, 0, debug() and 0.3 or 0.6},
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

function update(self, dt) end

function draw(self) end

return SkellyAxe
