local SkellyPush = {}
local IAbility = require 'src.abilities.IAbility'
local ShapeUtils = require 'src.util.ShapeUtils'

local cast, update, draw

local rgb = {1, 0, 0, 0.6}

function SkellyPush.new()
    local skellyPush = IAbility.new("Skelly Push", cast, update, draw, 2)

    return skellyPush
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
        draw = function(self, me) end
    })
end

function update(self, dt) end

function draw(self) end

return SkellyPush
