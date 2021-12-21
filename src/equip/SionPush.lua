local IAbility = require 'src.equip.IAbility'
local ShapeUtils = require 'src.util.ShapeUtils'

local SionPush = {}

local cast, update, draw

local rgb = {1, 0, 0, debug() and 0.3 or 0.6}

function SionPush.new()
    local sionPush = IAbility.new("Sion Push", cast, update, draw, 2)

    return sionPush
end

function cast(self, character)
    table.insert(character.effects, {
        name = "Push",
        drawable = true,
        duration = 3,
        dt = 0,
        push = {
            color = {r = 0.8, g = 0.8, b = 0.8, alpha = 1},
            radius = 2,
            width = 4
        },
        segments = {
            {
                time = 2.9,
                done = false,
                cast = function(self, me, effect)
                    effect.push = {
                        color = {r = 1, g = 0.2, b = 0.2, alpha = 0.2},
                        radius = 25,
                        width = 50
                    }
                end
            },
            {
                time = 2.95,
                done = false,
                cast = function(self, me)
                    me:submitHurtboxCircle("Push", 140, character.body:getX(), character.body:getY(), 50)
                end
            }
        },
        draw = function(self, me)
            love.graphics.setColor(
                self.push.color.r,
                self.push.color.g - self.push.color.g * self.dt / self.duration,
                self.push.color.b - self.push.color.b * self.dt / self.duration
            )
            love.graphics.setLineWidth(self.push.width)
            love.graphics.circle("line", character.body:getX(), character.body:getY(), character.meta.size + self.push.radius)
            love.graphics.setLineWidth(1)
        end
    })
end

function update(self, dt)

end

function draw()

end

return SionPush
