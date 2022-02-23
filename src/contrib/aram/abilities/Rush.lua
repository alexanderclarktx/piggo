local Rush = {}
local IAbility = require "src.piggo.core.IAbility"
local ShapeUtils = require "src.piggo.util.ShapeUtils"

local cast, update, draw

local rgb = {1, 0, 0, 0.6}

function Rush.new()
    local rush = IAbility.new("Skelly Ulti", cast, update, draw, 300)

    return rush
end

function cast(self, character)
    character.state.color = {0, 1, 0}
    table.insert(character.state.effects, {
        name = "Ulti",
        drawable = true,
        duration = 200,
        frame = 0,
        segments = {
            {
                time = 0,
                done = false,
                cast = function(self, me)
                    character.state.speedfactor = 4
                end
            },
            {
                time = 190,
                done = false,
                cast = function(self, me)
                    me:submitHurtboxCircle("Ulti", 9999999, character.state.body:getX(), character.state.body:getY(), 500)
                    character.state.hp = character.state.hp + 150
                    character.state.color = character.state.defaultColor
                    character.state.speedfactor = 1
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
            if self.frame > 190 then
                love.graphics.setLineWidth(1)
                love.graphics.setLineWidth(400)

                love.graphics.setColor(1, 0, 0, 0.3)
                love.graphics.setColor(math.random(), math.random(), math.random(), 0.8)
                love.graphics.circle("line", character.state.body:getX(), character.state.body:getY(), character.state.size + 50)
                love.graphics.setColor(math.random(), math.random(), math.random(), 0.8)
                love.graphics.circle("fill", character.state.body:getX(), character.state.body:getY(), character.state.size + 50)

                -- TODO i'm resetting the color - this should be a call
                love.graphics.setLineWidth(1)
            end
        end
    })
end

function update(self, dt) end

function draw(self) end

return Rush
