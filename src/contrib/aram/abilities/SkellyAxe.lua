local SkellyAxe = {}
local IAbility = require "src.piggo.core.IAbility"
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local cast, update, draw

-- hold down to charge; release for AoE stun and damage
function SkellyAxe.new()
    local skellyAxe = IAbility.new("Skelly Axe", cast, update, draw, 300)

    skellyAxe.charges = 4
    skellyAxe.maxCharges = 4
    skellyAxe.chargeCd = 1
    skellyAxe.chargeDt = 0

    return skellyAxe
end

function cast(self, character, mouseX, mouseY)
    assert(character and character.state.body and mouseX and mouseY)

    if self.frame <= self.cd then return end
    if self.charges <= 0 then return end
    self.charges = self.charges - 1

    -- calculate axe orientation
    local xdiff = mouseX - character.state.body:getX()
    local ydiff = mouseY - character.state.body:getY()
    local xRatio = .0 + xdiff / (math.abs(xdiff) + math.abs(ydiff))
    local yRatio = .0 + ydiff / (math.abs(xdiff) + math.abs(ydiff))

    table.insert(character.state.effects, {
        name = "Axe",
        drawable = true,
        color = {1, 0, 0, debug and 0.3 or 0.6},
        duration = 40,
        frame = 0,
        hitboxDistance = 200,
        hitboxAngle = math.pi/8,
        hitboxStyle = "line",
        xRatio = xRatio,
        yRatio = yRatio,
        segments = {
            {
                time = 35,
                done = false,
                cast = function(self, character, effect)
                    effect.hitboxStyle = "fill"

                    -- damage
                    character:submitHurtboxPoly("axe", 100, effect.hitboxPoints)
                end
            }
        },
        update = function(self, character)
            self.frame = self.frame + 1

            for _, segment in pairs(self.segments) do
                if not segment.done and segment.time <= self.frame then
                    segment:cast(character, self)
                    segment.done = true
                end
            end

            -- first point is on edge of character
            local p1 = {character.state.body:getX() + character.state.size * self.xRatio, character.state.body:getY() + character.state.size * self.yRatio}

            -- outer points of triangle
            local p2 = ShapeUtils.rotate({self.xRatio, self.yRatio}, -self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)
            local p3 = ShapeUtils.rotate({self.xRatio, self.yRatio}, self.hitboxAngle, p1[1], p1[2], self.hitboxDistance)
            
            -- polygon
            self.hitboxPoints = {p1[1], p1[2], p2[1], p2[2], p3[1], p3[2]}
        end,
        draw = function(self)
            -- draw axe triangle
            love.graphics.setColor(self.color)
            love.graphics.polygon(self.hitboxStyle, self.hitboxPoints)
        end
    })
end

function update(self) end

function draw(self) end

return SkellyAxe
