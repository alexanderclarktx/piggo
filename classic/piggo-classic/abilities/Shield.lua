local Shield = {}
local Ability = require "piggo-core.Ability"
local ShapeUtils = require "piggo-core.util.ShapeUtils"

local cast, update, draw

local rgb = {1, 0, 0, 0.6}

function Shield.new()
    local shield = Ability.new("Skelly Shield", cast, update, draw, 300)

    return shield
end

function cast(self, character)
    if self.frame < self.cd then return end

    table.insert(character.state.effects, {
        name = "Shield",
        drawable = true,
        duration = 80,
        frame = 0,
        shield = {
            color = {r = 0.8, g = 0.8, b = 0.8, alpha = 1},
            radius = 2,
            width = 4
        },
        segments = {
            {
                time = 70,
                done = false,
                cast = function(self, me, effect)
                    effect.shield = {
                        color = {r = 1, g = 0.2, b = 0.2, alpha = 0.2},
                        radius = 25,
                        width = 50
                    }
                end
            },
            {
                time = 75,
                done = false,
                cast = function(self, me)
                    me:submitHurtboxCircle("Shield", 140, character.state.body:getX(), character.state.body:getY(), 50)
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
        draw = function(self, me)
            love.graphics.setColor(
                self.shield.color.r,
                self.shield.color.g - self.shield.color.g * self.frame / self.duration,
                self.shield.color.b - self.shield.color.b * self.frame / self.duration
            )
            love.graphics.setLineWidth(self.shield.width)
            love.graphics.circle("line", character.state.body:getX(), character.state.body:getY(), character.state.size + self.shield.radius)
            love.graphics.setLineWidth(1)
        end
    })
end

function update(self) end

function draw(self) end

return Shield
