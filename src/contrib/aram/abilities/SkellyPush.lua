local SkellyPush = {}
local IAbility = require "src.piggo.core.IAbility"
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local cast, update, draw

local rgb = {1, 0, 0, 0.6}

function SkellyPush.new()
    local skellyPush = IAbility.new("Skelly Push", cast, update, draw, 300)

    return skellyPush
end

function cast(self, character)
    table.insert(character.state.effects, {
        name = "Push",
        drawable = true,
        duration = 100,
        frame = 0,
        push = {
            color = {r = 0.8, g = 0.8, b = 0.8, alpha = 1},
            radius = 2,
            width = 4
        },
        segments = {
            {
                time = 90,
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
                time = 95,
                done = false,
                cast = function(self, me)
                    me:submitHurtboxCircle("Push", 140, character.state.body:getX(), character.state.body:getY(), 50)
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
        end,
        draw = function(self, me) end
    })
end

function update(self) end

function draw(self) end

return SkellyPush
