local IAbility = require 'src.equip.IAbility'
local ShapeUtils = require 'src.util.ShapeUtils'

local SionUlti = {}

local cast, update, draw

local rgb = {1, 0, 0, debug() and 0.3 or 0.6}

function SionUlti.new()
    local sionUlti = IAbility.new("Sion Ulti", cast, update, draw, 10)

    return sionUlti
end

function cast(self, character)
    character.color = {0, 1, 0}
    table.insert(character.effects, {
        name = "Ulti",
        drawable = true,
        duration = 2,
        dt = 0,
        segments = {
            {
                time = 0,
                done = false,
                cast = function(self, me)
                    character.meta.speedfactor = 4
                end
            },
            {
                time = 1.8,
                done = false,
                cast = function(self, me)
                    me:submitHurtboxCircle("Ulti", 9999999, character.body:getX(), character.body:getY(), 500)
                    character.meta.hp = character.meta.hp + 150
                    character.color = character.defaultColor
                    character.meta.speedfactor = 1
                end
            }
        },
        draw = function(self, me)
            if self.dt > 1.8 then
                love.graphics.setLineWidth(1)
                love.graphics.setLineWidth(400)

                love.graphics.setColor(1, 0, 0, 0.3)
                love.graphics.setColor(math.random(), math.random(), math.random(), 0.8)
                love.graphics.circle("line", character.body:getX(), character.body:getY(), character.meta.size + 50)
                love.graphics.setColor(math.random(), math.random(), math.random(), 0.8)
                love.graphics.circle("fill", character.body:getX(), character.body:getY(), character.meta.size + 50)

                -- TODO i'm resetting the color - this should be a call
                love.graphics.setLineWidth(1)
            end
        end
    })
end

function update(self, dt)
    if collision then
        
    end
end

function draw()

end

return SionUlti
